`timescale 1ns/1ns
module mi (
    input clk,
    input reset
);

    // ---- IF ----
    wire [31:0] pc_IF;
    wire [31:0] pc_next_IF;
    wire [31:0] pc_plus4_IF;
    wire [31:0] instr_IF;

    // ---- IF/ID ----
    wire [31:0] instr_ID;
    wire [31:0] pc_plus4_ID_buf;

    // ---- ID (burrote) ----
    wire salto_ID;
    wire branch_ID;
    wire mem_leer_ID;
    wire mem_a_reg_ID;
    wire mem_escribir_ID;
    wire alu_fuente_ID;
    wire reg_escribir_ID;  // FALTABA ESTA SEÑAL
    wire [1:0] alu_operacion_ID;

    wire [31:0] salida_corrimiento_ID;
    wire [31:0] dr1_ID;
    wire [31:0] dr2_ID;
    wire [31:0] inmediato_ext_ID;
    wire [5:0]  funct_ID;
    wire [4:0]  rt_ID;
    wire [4:0]  rd_ID;
    wire [31:0] pc_plus4_ID;
    wire [31:0] jump_address_ID;
    wire [31:0] dato_escribir_ID;  // PARA EL BANCO DE REGISTROS

    // ---- ID/EX ----
    wire reg_escribir_EX_ctrl;
    wire mem_a_reg_EX_ctrl;
    wire mem_escribir_EX_ctrl;
    wire mem_leer_EX_ctrl;
    wire branch_EX_ctrl;
    wire alu_fuente_EX_ctrl;
    wire salto_EX_ctrl;
    wire [1:0] alu_operacion_EX_ctrl;

    wire [31:0] pc_plus4_EX;
    wire [31:0] dr1_EX;
    wire [31:0] dr2_EX;
    wire [31:0] inmediato_ext_EX;
    wire [31:0] jump_address_EX;
    wire [31:0] salida_corrimiento_EX;  // FALTABA
    wire [4:0]  rt_EX;
    wire [4:0]  rd_EX;
    wire [5:0]  funct_EX;

    // ---- EX ----
    wire [31:0] resultado_alu_EX;
    wire [31:0] dr2_forward_EX;
    wire [4:0]  registro_destino_EX;

    wire [31:0] proximo_pc_EX;

    wire reg_escribir_MEM_ctrl_EX;
    wire mem_a_reg_MEM_ctrl_EX;
    wire mem_escribir_MEM_ctrl_EX;
    wire mem_leer_MEM_ctrl_EX;

    // ---- EX/MEM ----
    wire reg_escribir_MEM;
    wire mem_a_reg_MEM;
    wire mem_escribir_MEM;
    wire mem_leer_MEM;

    wire branch_habilitado_MEM;
    wire [31:0] branch_target_MEM;

    wire [31:0] resultado_alu_MEM;
    wire [31:0] dr2_forward_MEM;
    wire [4:0]  registro_destino_MEM;

    // ---- MEM ----
    wire [31:0] dato_memoria_MEM;  // SALIDA DE MEMORIA DE DATOS
    wire [31:0] resultado_alu_MEM_pasado;
    wire [4:0]  rd_MEM;
    wire mem_a_reg_MEM_pasado;
    wire reg_escribir_MEM_pasado;

    // ---- MEM/WB ----
    wire reg_escribir_WB;
    wire mem_a_reg_WB;
    wire [31:0] dato_memoria_WB;
    wire [31:0] resultado_alu_WB;
    wire [4:0]  registro_destino_WB;

    // ---- WB ----
    wire [31:0] write_data_WB;

    // =====================================================
    // 1) IF: PC + MEMORIA DE INSTRUCCIONES
    // =====================================================

    program_counter u_pc (
        .clk_pc (clk),
        .reset  (reset),
        .pc_in  (pc_next_IF),
        .pc_out (pc_IF)
    );

    adicion u_add4 (
        .opIn  (pc_IF),
        .opIn2 (32'd4),
        .opNext(pc_plus4_IF)
    );

    memoria_instrucciones u_imem (
        .dir (pc_IF[7:0]),  // Considera usar más bits si tu memoria es más grande
        .inst(instr_IF)
    );

    assign pc_next_IF = proximo_pc_EX;

    // =====================================================
    // 2) Buffer IF/ID
    // =====================================================

    buf1 u_buf_IF_ID (
        .clk_buf1    (clk),
        .reset_buf1  (reset),
        .instruccion_in (instr_IF),
        .pc_plus4_in    (pc_plus4_IF),
        .instruccion_out(instr_ID),
        .pc_plus4_out   (pc_plus4_ID_buf)
    );

    // =====================================================
    // 3) ID: burrote (Unidad de Control + Banco Registros)
    // =====================================================

    burrote u_ID (
        .clk            (clk),
        .instruccion    (instr_ID),
        .pc_plus4_out   (pc_plus4_ID_buf),
        .dato_escribir  (write_data_WB),

        .salto_uc       (salto_ID),
        .branch_uc      (branch_ID),
        .mem_leer_uc    (mem_leer_ID),
        .mem_a_reg_uc   (mem_a_reg_ID),
        .mem_escribir_uc(mem_escribir_ID),
        .alu_fuente_uc  (alu_fuente_ID),
        .reg_escribir_uc(reg_escribir_ID),  // AÑADIDO
        .alu_operacion_uc(alu_operacion_ID),

        .salida_corrimiento(salida_corrimiento_ID),
        .dr1_salida     (dr1_ID),
        .dr2_salida     (dr2_ID),
        .salida_ext     (inmediato_ext_ID),
        .funct_out      (funct_ID),
        .pc_plus4_ID    (pc_plus4_ID),
        .rt_out         (rt_ID),
        .rd_out         (rd_ID),
        .jump_address_out(jump_address_ID)
    );

    // =====================================================
    // 4) Buffer ID/EX - CORREGIDO
    // =====================================================

    buffer2_ID_EX u_buf_ID_EX (
        .clk(clk),
        .reset(reset),

        // Control ID → EX - CORREGIDO
        .reg_escribir_ID(reg_escribir_ID),
        .mem_a_reg_ID   (mem_a_reg_ID),
        .mem_escribir_ID(mem_escribir_ID),
        .mem_leer_ID    (mem_leer_ID),
        .branch_ID      (branch_ID),
        .alu_fuente_ID  (alu_fuente_ID),
        .alu_operacion_ID(alu_operacion_ID),
        .salto_ID       (salto_ID),

        // Datos ID → EX - CORREGIDO
        .pc_plus4_ID    (pc_plus4_ID),
        .dr1_ID         (dr1_ID),
        .dr2_ID         (dr2_ID),
        .inmediato_ext_ID(inmediato_ext_ID),
        .salida_corrimiento_ID(salida_corrimiento_ID),
        .rt_ID          (rt_ID),
        .rd_ID          (rd_ID),
        .funct_ID       (funct_ID),
        .jump_address_ID(jump_address_ID),

        // Salidas hacia EX
        .reg_escribir_EX   (reg_escribir_EX_ctrl),
        .mem_a_reg_EX      (mem_a_reg_EX_ctrl),
        .mem_escribir_EX   (mem_escribir_EX_ctrl),
        .mem_leer_EX       (mem_leer_EX_ctrl),
        .branch_EX         (branch_EX_ctrl),
        .alu_fuente_EX     (alu_fuente_EX_ctrl),
        .salto_EX          (salto_EX_ctrl),
        .alu_operacion_EX  (alu_operacion_EX_ctrl),

        .pc_plus4_EX       (pc_plus4_EX),
        .dr1_EX            (dr1_EX),
        .dr2_EX            (dr2_EX),
        .inmediato_ext_EX  (inmediato_ext_EX),
        .salida_corrimiento_EX(salida_corrimiento_EX),
        .rt_EX             (rt_EX),
        .rd_EX             (rd_EX),
        .funct_EX          (funct_EX),
        .jump_address_EX   (jump_address_EX)
    );

    // =====================================================
    // 5) EX
    // =====================================================

    EXE u_EX (
        .pc_plus4_EX      (pc_plus4_EX),
        .dr1_EX           (dr1_EX),
        .dr2_EX           (dr2_EX),
        .inmediato_ext_EX (inmediato_ext_EX),
        .jump_address_EX  (jump_address_EX),
        .rt_EX            (rt_EX),
        .rd_EX            (rd_EX),
        .funct_EX         (funct_EX),

        .salto_EX         (salto_EX_ctrl),
        .reg_escribir_EX  (reg_escribir_EX_ctrl),
        .mem_a_reg_EX     (mem_a_reg_EX_ctrl),
        .mem_escribir_EX  (mem_escribir_EX_ctrl),
        .mem_leer_EX      (mem_leer_EX_ctrl),
        .branch_EX        (branch_EX_ctrl),
        .alu_fuente_EX    (alu_fuente_EX_ctrl),
        .alu_operacion_EX (alu_operacion_EX_ctrl),

        .resultado_alu_EX_out (resultado_alu_EX),
        .dr2_forward_EX_out   (dr2_forward_EX),
        .registro_destino_EX_out(registro_destino_EX),
        .proximo_pc_EX_out    (proximo_pc_EX),

        .reg_escribir_MEM_ctrl(reg_escribir_MEM_ctrl_EX),
        .mem_a_reg_MEM_ctrl   (mem_a_reg_MEM_ctrl_EX),
        .mem_escribir_MEM_ctrl(mem_escribir_MEM_ctrl_EX),
        .mem_leer_MEM_ctrl    (mem_leer_MEM_ctrl_EX)
    );

    // =====================================================
    // 6) Buffer EX/MEM
    // =====================================================

    buffer_EX_MEM u_buf_EX_MEM (
        .clk                       (clk),
        .reset                     (reset),

        .reg_escribir_MEM_ctrl_EX  (reg_escribir_MEM_ctrl_EX),
        .mem_a_reg_MEM_ctrl_EX     (mem_a_reg_MEM_ctrl_EX),
        .mem_escribir_MEM_ctrl_EX  (mem_escribir_MEM_ctrl_EX),
        .mem_leer_MEM_ctrl_EX      (mem_leer_MEM_ctrl_EX),

        .resultado_alu_EX          (resultado_alu_EX),
        .dr2_forward_EX            (dr2_forward_EX),
        .registro_destino_EX       (registro_destino_EX),

        .reg_escribir_MEM          (reg_escribir_MEM),
        .mem_a_reg_MEM             (mem_a_reg_MEM),
        .mem_escribir_MEM          (mem_escribir_MEM),
        .mem_leer_MEM              (mem_leer_MEM),

        .branch_habilitado_MEM     (branch_habilitado_MEM),
        .branch_target_MEM         (branch_target_MEM),

        .resultado_alu_MEM         (resultado_alu_MEM),
        .dr2_forward_MEM           (dr2_forward_MEM),
        .registro_destino_MEM      (registro_destino_MEM)
    );

    // =====================================================
    // 7) MEM - CORREGIDO
    // =====================================================

    MEM u_MEM (
        .clk                 (clk),
        .reg_escribir_MEM    (reg_escribir_MEM),
        .mem_a_reg_MEM       (mem_a_reg_MEM),
        .mem_escribir_MEM    (mem_escribir_MEM),
        .mem_leer_MEM        (mem_leer_MEM),

        .resultado_alu_MEM     (resultado_alu_MEM),
        .dr2_forward_MEM       (dr2_forward_MEM),
        .registro_destino_MEM  (registro_destino_MEM),

        .dato_memoria_out      (dato_memoria_MEM),
        .alu_result_out        (resultado_alu_MEM_pasado),
        .rd_out                (rd_MEM),
        .mem_a_reg_out         (mem_a_reg_MEM_pasado),
        .reg_escribir_out      (reg_escribir_MEM_pasado)
    );

    // =====================================================
    // 8) Buffer MEM/WB - CORREGIDO
    // =====================================================

    buffer_MEM_WB u_buf_MEM_WB (
        .clk                    (clk),
        .reset                  (reset),

        .reg_escribir_MEM       (reg_escribir_MEM_pasado),
        .mem_a_reg_MEM          (mem_a_reg_MEM_pasado),

        .dato_memoria_MEM       (dato_memoria_MEM),
        .resultado_alu_MEM      (resultado_alu_MEM_pasado),
        .registro_destino_MEM   (rd_MEM),  // Usamos rd_MEM

        .reg_escribir_WB        (reg_escribir_WB),
        .mem_a_reg_WB           (mem_a_reg_WB),
        .dato_memoria_WB        (dato_memoria_WB),
        .resultado_alu_WB       (resultado_alu_WB),
        .registro_destino_WB    (registro_destino_WB)
    );

    // =====================================================
    // 9) Write-Back
    // =====================================================

    // MUX para seleccionar dato a escribir en banco de registros
    assign write_data_WB = (mem_a_reg_WB) ? dato_memoria_WB : resultado_alu_WB;

    // NOTA: No necesitas un módulo WB separado si solo es un mux
    // El write-back ya está hecho aquí con el mux

endmodule
