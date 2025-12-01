`timescale 1ns/1ns
module tb_mi();

    reg clk;
    reg reset;

    // Instancia del procesador completo
    mi uut (
        .clk(clk),
        .reset(reset)
    );

    // Generador de reloj: periodo 10ns (100MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Secuencia de reset
    initial begin
        reset = 1;
        #20;
        reset = 0;

        // Tiempo de simulación
        #500;    // puedes aumentar si tu programa es más largo

        $finish;
    end

    // Para ver los valores en terminal
    initial begin
        $monitor("t=%0dns | PC=%h | InstrID=%h | WriteDataWB=%h | rd=%d",
            $time,
            uut.pc_IF,
            uut.instr_ID,
            uut.write_data_WB,
            uut.registro_destino_WB
        );
    end

endmodule

