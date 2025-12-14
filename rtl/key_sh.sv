module key_sh (
    input  logic        clk,
    input  logic        rst,
    input  logic        start_key_gen,
    input  logic [127:0] master_key,
    output logic [575:0] round_keys,  // 9×64 = 576 бит: k0..k8
    output logic        keys_ready
);

    // Константы ci для генерации ключей
    logic [63:0] CI_CONSTANTS [0:8];
    
    initial begin
        CI_CONSTANTS[0] = 64'h290D61409CEB9E8F;  // c0
        CI_CONSTANTS[1] = 64'h1F855F585B013986;  // c1
        CI_CONSTANTS[2] = 64'h972ED7D635AE1716;  // c2
        CI_CONSTANTS[3] = 64'h21B6694EA5728708;  // c3
        CI_CONSTANTS[4] = 64'h3C18E6E7FAADB889;  // c4
        CI_CONSTANTS[5] = 64'hB700F76F73841163;  // c5
        CI_CONSTANTS[6] = 64'h3F967F6EBF149DAC;  // c6
        CI_CONSTANTS[7] = 64'hA40E7EF6204A6230;  // c7
        CI_CONSTANTS[8] = 64'h03C54B5A46A34465;  // c8
    end
    
    // Внутренние регистры
    logic [63:0] k_prev2;  // k_{i-2}
    logic [63:0] k_prev1;  // k_{i-1}
    logic [63:0] fci_out;  // Fci(k_{i-1})
    logic [63:0] k_current; // k_i
    logic [3:0]  counter;   // 0..8 для k0..k8
    logic        gen_active;
    
    // Экземпляр fci_func
    fci_func fci_inst (
        .ci    (CI_CONSTANTS[counter]),  // ci для текущего ki
        .iword (k_prev1),                // k_{i-1}
        .oword (fci_out)                 // Fci(k_{i-1})
    );
    
    // Формула: ki = k_{i-2} ⊕ Fci(k_{i-1})
    assign k_current = k_prev2 ^ fci_out;
    
    always @(posedge clk) begin
        if (rst) begin
            // Сброс
            keys_ready <= 1'b0;
            gen_active <= 1'b0;
            counter <= 4'd0;
            k_prev2 <= 64'b0;
            k_prev1 <= 64'b0;
            round_keys <= 576'b0;
        end else begin
            if (start_key_gen && !gen_active) begin
                // Инициализация: master_key содержит k_{-2} и k_{-1}
                k_prev2 <= master_key[63:0];    // k_{-2}
                k_prev1 <= master_key[127:64];  // k_{-1}
                counter <= 4'd0;
                gen_active <= 1'b1;
                keys_ready <= 1'b0;
                round_keys <= 576'b0;
                
            end else if (gen_active) begin
                // Сохраняем текущий ключ в правильную позицию
                case (counter)
                    0: round_keys[63:0]    <= k_current;    // k0
                    1: round_keys[127:64]  <= k_current;    // k1
                    2: round_keys[191:128] <= k_current;    // k2
                    3: round_keys[255:192] <= k_current;    // k3
                    4: round_keys[319:256] <= k_current;    // k4
                    5: round_keys[383:320] <= k_current;    // k5
                    6: round_keys[447:384] <= k_current;    // k6
                    7: round_keys[511:448] <= k_current;    // k7
                    8: round_keys[575:512] <= k_current;    // k8
                endcase
                
                // Обновляем k_{i-2} и k_{i-1} для следующего ключа
                k_prev2 <= k_prev1;    // k_{i-1} становится k_{i-2}
                k_prev1 <= k_current;  // k_i становится k_{i-1}
                
                if (counter == 4'd8) begin
                    // Все 9 ключей сгенерированы
                    gen_active <= 1'b0;
                    keys_ready <= 1'b1;
                end else begin
                    counter <= counter + 4'd1;
                end
            end
        end
    end

endmodule