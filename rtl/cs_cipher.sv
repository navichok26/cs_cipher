module cs_cipher (
    input  logic        clk,
    input  logic        rst,           // активный высокий уровень
    input  logic        s_axis_tvalid,
    input  logic [63:0] s_axis_tdata,
    output logic        s_axis_tready,
    output logic        m_axis_tvalid,
    output logic [63:0] m_axis_tdata,
    input  logic        m_axis_tready,
    input  logic [127:0] master_key
);

    // ========== Генерация ключей ==========
    logic        start_key_gen;
    logic        keys_ready;
    logic [575:0] round_keys;  // k0..k8
    
    // Модуль генерации ключей
    key_sh key_gen_inst (
        .clk           (clk),
        .rst           (rst),
        .start_key_gen (start_key_gen),
        .master_key    (master_key),
        .round_keys    (round_keys),
        .keys_ready    (keys_ready)
    );
    
    // Извлекаем отдельные ключи из round_keys
    logic [63:0] k0, k1, k2, k3, k4, k5, k6, k7, k8;
    assign k0 = round_keys[63:0];      // k0
    assign k1 = round_keys[127:64];    // k1
    assign k2 = round_keys[191:128];   // k2
    assign k3 = round_keys[255:192];   // k3
    assign k4 = round_keys[319:256];   // k4
    assign k5 = round_keys[383:320];   // k5
    assign k6 = round_keys[447:384];   // k6
    assign k7 = round_keys[511:448];   // k7
    assign k8 = round_keys[575:512];   // k8
    
    // ========== Регистры состояния ==========
    logic [63:0] state_reg;      // Текущее состояние шифрования
    logic [3:0]  round_counter;  // 0..8
    
    // ========== Модуль раунда ==========
    logic [63:0] round_out;
    
    // Выбор текущего ключа для раунда
    logic [63:0] current_key;
    always @(*) begin
        case (round_counter)
            4'd0: current_key = k0;
            4'd1: current_key = k1;
            4'd2: current_key = k2;
            4'd3: current_key = k3;
            4'd4: current_key = k4;
            4'd5: current_key = k5;
            4'd6: current_key = k6;
            4'd7: current_key = k7;
            default: current_key = 64'b0;
        endcase
    end
    
    // Модуль раунда (комбинационный)
    round round_inst (
        .data_in  (state_reg),
        .subkey   (current_key),
        .data_out (round_out)
    );
    
    // ========== FSM состояния ==========
    typedef enum logic [3:0] {
        IDLE,
        KEY_GEN,
        READY,
        LOAD_DATA,
        PROCESS_ROUNDS,
        FINAL_XOR,
        OUTPUT
    } state_t;
    
    state_t state, next_state;
    
    // Основной FSM
    always_ff @(posedge clk) begin
        if (rst) begin
            state <= IDLE;
            s_axis_tready <= 1'b0;
            m_axis_tvalid <= 1'b0;
            m_axis_tdata <= 64'b0;
            state_reg <= 64'b0;
            round_counter <= 4'd0;
            start_key_gen <= 1'b0;
        end else begin
            state <= next_state;
            
            case (state)
                IDLE: begin
                    s_axis_tready <= 1'b0;
                    m_axis_tvalid <= 1'b0;
                    start_key_gen <= 1'b1;
                end
                
                KEY_GEN: begin
                    // start_key_gen остается 1 пока не сгенерированы ключи
                    if (keys_ready) begin
                        start_key_gen <= 1'b0;
                        s_axis_tready <= 1'b1;
                    end
                end
                
                READY: begin
                    // Ожидание данных
                    s_axis_tready <= 1'b1;
                    if (s_axis_tvalid) begin
                        state_reg <= s_axis_tdata;
                        s_axis_tready <= 1'b0;
                        round_counter <= 4'd0;
                    end
                end
                
                LOAD_DATA: begin
                    // Просто переходной состояние
                    // Данные уже загружены в READY
                end
                
                PROCESS_ROUNDS: begin
                    // Выполнение раундов 0-7
                    state_reg <= round_out;
                    round_counter <= round_counter + 4'd1;
                end
                
                FINAL_XOR: begin
                    // Финальный XOR с k8
                    state_reg <= state_reg ^ k8;
                end
                
                OUTPUT: begin
                    m_axis_tdata <= state_reg;
                    m_axis_tvalid <= 1'b1;
                    if (m_axis_tready && m_axis_tvalid) begin
                        m_axis_tvalid <= 1'b0;
                        s_axis_tready <= 1'b1;
                    end
                end
            endcase
        end
    end
    
    // Логика переходов FSM
    always @(*) begin
        next_state = state;
        
        case (state)
            IDLE: begin
                next_state = KEY_GEN;
            end
            
            KEY_GEN: begin
                if (keys_ready) next_state = READY;
            end
            
            READY: begin
                if (s_axis_tvalid) next_state = LOAD_DATA;
            end
            
            LOAD_DATA: begin
                next_state = PROCESS_ROUNDS;
            end
            
            PROCESS_ROUNDS: begin
                if (round_counter < 7) begin
                    next_state = PROCESS_ROUNDS;  // Еще раунды
                end else if (round_counter == 7) begin
                    next_state = FINAL_XOR;       // Все 8 раундов завершены
                end
            end
            
            FINAL_XOR: begin
                next_state = OUTPUT;
            end
            
            OUTPUT: begin
                if (m_axis_tready && m_axis_tvalid) begin
                    next_state = READY;
                end
            end
            
            default: next_state = IDLE;
        endcase
    end

endmodule