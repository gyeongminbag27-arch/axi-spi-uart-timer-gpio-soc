`timescale 1 ns / 1 ps

module spi_axi_v1_0_S00_AXI #
(
    parameter integer C_S_AXI_DATA_WIDTH = 32,
    parameter integer C_S_AXI_ADDR_WIDTH = 5
)
(
    // User ports
    output reg        spi_start,
    output wire       spi_cpol,
    output wire       spi_cpha,
    output wire [7:0] spi_clk_div,

    output wire [7:0] spi_m_tx_data,
    input  wire       spi_m_busy,
    input  wire [7:0] spi_m_rx_data,
    input  wire       spi_m_done,

    output wire       spi_loopback_en,
    output wire [7:0] spi_s_tx_data,
    input  wire [7:0] spi_s_rx_data,
    input  wire       spi_s_done,

    output wire       spi_int_en,
    output reg        irq_pending,

    output wire       lcd_dc,
    output wire       lcd_rst,

    // Global Clock Signal
    input wire S_AXI_ACLK,
    // Global Reset Signal. This Signal is Active LOW
    input wire S_AXI_ARESETN,

    // Write address
    input wire [C_S_AXI_ADDR_WIDTH-1 : 0] S_AXI_AWADDR,
    input wire [2 : 0] S_AXI_AWPROT,
    input wire S_AXI_AWVALID,
    output wire S_AXI_AWREADY,

    // Write data
    input wire [C_S_AXI_DATA_WIDTH-1 : 0] S_AXI_WDATA,
    input wire [(C_S_AXI_DATA_WIDTH/8)-1 : 0] S_AXI_WSTRB,
    input wire S_AXI_WVALID,
    output wire S_AXI_WREADY,

    // Write response
    output wire [1 : 0] S_AXI_BRESP,
    output wire S_AXI_BVALID,
    input wire S_AXI_BREADY,

    // Read address
    input wire [C_S_AXI_ADDR_WIDTH-1 : 0] S_AXI_ARADDR,
    input wire [2 : 0] S_AXI_ARPROT,
    input wire S_AXI_ARVALID,
    output wire S_AXI_ARREADY,

    // Read data
    output wire [C_S_AXI_DATA_WIDTH-1 : 0] S_AXI_RDATA,
    output wire [1 : 0] S_AXI_RRESP,
    output wire S_AXI_RVALID,
    input wire S_AXI_RREADY
);

    // ------------------------------------------------------------
    // AXI4-Lite internal signals
    // ------------------------------------------------------------
    reg [C_S_AXI_ADDR_WIDTH-1 : 0] axi_awaddr;
    reg axi_awready;
    reg axi_wready;
    reg [1 : 0] axi_bresp;
    reg axi_bvalid;
    reg [C_S_AXI_ADDR_WIDTH-1 : 0] axi_araddr;
    reg axi_arready;
    reg [C_S_AXI_DATA_WIDTH-1 : 0] axi_rdata;
    reg [1 : 0] axi_rresp;
    reg axi_rvalid;

    localparam integer ADDR_LSB = (C_S_AXI_DATA_WIDTH/32) + 1; // 2
    localparam integer OPT_MEM_ADDR_BITS = 2;                  // 8 regs, use [4:2]

    // ------------------------------------------------------------
    // Register Map
    // ------------------------------------------------------------
    // 0x00 SPI_CR
    //      bit[0] = start pulse
    //      bit[1] = cpol
    //      bit[2] = cpha
    //      bit[3] = int_en
    //      bit[4] = lcd_dc
    //      bit[5] = lcd_rst
    //      bit[6] = loopback_en
    //
    // 0x04 SPI_SR
    //      bit[0] = master_done
    //      bit[1] = master_busy
    //      bit[2] = irq_pending
    //      bit[3] = slave_done
    //
    // 0x08 SPI_CLKDIV
    // 0x0C SPI_M_TXD
    // 0x10 SPI_M_RXD
    // 0x14 SPI_S_TXD
    // 0x18 SPI_S_RXD
    // 0x1C SPI_IRQ_CLR
    // ------------------------------------------------------------

    reg [31:0] spi_cr;
    reg [31:0] spi_clkdiv;
    reg [31:0] spi_m_txd;
    reg [31:0] spi_s_txd;

    wire slv_reg_rden;
    wire slv_reg_wren;
    reg [C_S_AXI_DATA_WIDTH-1:0] reg_data_out;
    reg aw_en;

    wire [2:0] write_addr_sel;
    wire [2:0] read_addr_sel;

    assign write_addr_sel = axi_awaddr[ADDR_LSB+OPT_MEM_ADDR_BITS : ADDR_LSB];
    assign read_addr_sel  = axi_araddr[ADDR_LSB+OPT_MEM_ADDR_BITS : ADDR_LSB];

    // register field mapping
    assign spi_cpol        = spi_cr[1];
    assign spi_cpha        = spi_cr[2];
    assign spi_int_en      = spi_cr[3];
    assign lcd_dc          = spi_cr[4];
    assign lcd_rst         = spi_cr[5];
    assign spi_loopback_en = spi_cr[6];

    assign spi_clk_div     = spi_clkdiv[7:0];
    assign spi_m_tx_data   = spi_m_txd[7:0];
    assign spi_s_tx_data   = spi_s_txd[7:0];

    // AXI output assignment
    assign S_AXI_AWREADY = axi_awready;
    assign S_AXI_WREADY  = axi_wready;
    assign S_AXI_BRESP   = axi_bresp;
    assign S_AXI_BVALID  = axi_bvalid;
    assign S_AXI_ARREADY = axi_arready;
    assign S_AXI_RDATA   = axi_rdata;
    assign S_AXI_RRESP   = axi_rresp;
    assign S_AXI_RVALID  = axi_rvalid;

    // ------------------------------------------------------------
    // AXI Write Address Ready
    // ------------------------------------------------------------
    always @(posedge S_AXI_ACLK) begin
        if (S_AXI_ARESETN == 1'b0) begin
            axi_awready <= 1'b0;
            aw_en       <= 1'b1;
        end else begin
            if (~axi_awready && S_AXI_AWVALID && S_AXI_WVALID && aw_en) begin
                axi_awready <= 1'b1;
                aw_en       <= 1'b0;
            end else if (S_AXI_BREADY && axi_bvalid) begin
                aw_en       <= 1'b1;
                axi_awready <= 1'b0;
            end else begin
                axi_awready <= 1'b0;
            end
        end
    end

    // ------------------------------------------------------------
    // AXI Write Address Latch
    // ------------------------------------------------------------
    always @(posedge S_AXI_ACLK) begin
        if (S_AXI_ARESETN == 1'b0) begin
            axi_awaddr <= 0;
        end else begin
            if (~axi_awready && S_AXI_AWVALID && S_AXI_WVALID && aw_en) begin
                axi_awaddr <= S_AXI_AWADDR;
            end
        end
    end

    // ------------------------------------------------------------
    // AXI Write Data Ready
    // ------------------------------------------------------------
    always @(posedge S_AXI_ACLK) begin
        if (S_AXI_ARESETN == 1'b0) begin
            axi_wready <= 1'b0;
        end else begin
            if (~axi_wready && S_AXI_WVALID && S_AXI_AWVALID && aw_en) begin
                axi_wready <= 1'b1;
            end else begin
                axi_wready <= 1'b0;
            end
        end
    end

    assign slv_reg_wren = axi_wready && S_AXI_WVALID && axi_awready && S_AXI_AWVALID;

    // ------------------------------------------------------------
    // Register Write
    // ------------------------------------------------------------
    always @(posedge S_AXI_ACLK) begin
        if (S_AXI_ARESETN == 1'b0) begin
            spi_cr      <= 32'd0;
            spi_clkdiv  <= 32'd10;
            spi_m_txd   <= 32'd0;
            spi_s_txd   <= 32'd0;
            spi_start   <= 1'b0;
            irq_pending <= 1'b0;
        end else begin
            // start는 1-clock pulse
            spi_start <= 1'b0;

            // master done 시 pending set
            if (spi_m_done) begin
                irq_pending <= 1'b1;
            end

            if (slv_reg_wren) begin
                case (write_addr_sel)
                    3'h0: begin
                        // SPI_CR
                        // bit[0] start는 저장하지 않고 pulse만 발생
                        spi_cr[31:1] <= S_AXI_WDATA[31:1];

                        if (S_AXI_WDATA[0] && !spi_m_busy) begin
                            spi_start <= 1'b1;
                        end
                    end

                    3'h2: begin
                        // SPI_CLKDIV
                        spi_clkdiv <= S_AXI_WDATA;
                    end

                    3'h3: begin
                        // SPI_M_TXD
                        spi_m_txd <= S_AXI_WDATA;
                    end

                    3'h5: begin
                        // SPI_S_TXD
                        spi_s_txd <= S_AXI_WDATA;
                    end

                    3'h7: begin
                        // SPI_IRQ_CLR
                        if (S_AXI_WDATA[0]) begin
                            irq_pending <= 1'b0;
                        end
                    end

                    default: begin
                    end
                endcase
            end
        end
    end

    // ------------------------------------------------------------
    // AXI Write Response
    // ------------------------------------------------------------
    always @(posedge S_AXI_ACLK) begin
        if (S_AXI_ARESETN == 1'b0) begin
            axi_bvalid <= 1'b0;
            axi_bresp  <= 2'b00;
        end else begin
            if (axi_awready && S_AXI_AWVALID && ~axi_bvalid &&
                axi_wready && S_AXI_WVALID) begin
                axi_bvalid <= 1'b1;
                axi_bresp  <= 2'b00; // OKAY
            end else if (S_AXI_BREADY && axi_bvalid) begin
                axi_bvalid <= 1'b0;
            end
        end
    end

    // ------------------------------------------------------------
    // AXI Read Address Ready
    // ------------------------------------------------------------
    always @(posedge S_AXI_ACLK) begin
        if (S_AXI_ARESETN == 1'b0) begin
            axi_arready <= 1'b0;
            axi_araddr  <= 0;
        end else begin
            if (~axi_arready && S_AXI_ARVALID) begin
                axi_arready <= 1'b1;
                axi_araddr  <= S_AXI_ARADDR;
            end else begin
                axi_arready <= 1'b0;
            end
        end
    end

    // ------------------------------------------------------------
    // AXI Read Valid
    // ------------------------------------------------------------
    always @(posedge S_AXI_ACLK) begin
        if (S_AXI_ARESETN == 1'b0) begin
            axi_rvalid <= 1'b0;
            axi_rresp  <= 2'b00;
        end else begin
            if (axi_arready && S_AXI_ARVALID && ~axi_rvalid) begin
                axi_rvalid <= 1'b1;
                axi_rresp  <= 2'b00; // OKAY
            end else if (axi_rvalid && S_AXI_RREADY) begin
                axi_rvalid <= 1'b0;
            end
        end
    end

    assign slv_reg_rden = axi_arready & S_AXI_ARVALID & ~axi_rvalid;

    // ------------------------------------------------------------
    // Register Read Mux
    // ------------------------------------------------------------
    always @(*) begin
        case (read_addr_sel)
            3'h0: begin
                // SPI_CR
                // start bit은 pulse라 read 시 0
                reg_data_out = {spi_cr[31:1], 1'b0};
            end

            3'h1: begin
                // SPI_SR
                // bit[0] master_done
                // bit[1] master_busy
                // bit[2] irq_pending
                // bit[3] slave_done
                reg_data_out = {28'd0, spi_s_done, irq_pending, spi_m_busy, spi_m_done};
            end

            3'h2: begin
                // SPI_CLKDIV
                reg_data_out = spi_clkdiv;
            end

            3'h3: begin
                // SPI_M_TXD
                reg_data_out = spi_m_txd;
            end

            3'h4: begin
                // SPI_M_RXD
                reg_data_out = {24'd0, spi_m_rx_data};
            end

            3'h5: begin
                // SPI_S_TXD
                reg_data_out = spi_s_txd;
            end

            3'h6: begin
                // SPI_S_RXD
                reg_data_out = {24'd0, spi_s_rx_data};
            end

            3'h7: begin
                // SPI_IRQ_CLR read value
                reg_data_out = 32'd0;
            end

            default: begin
                reg_data_out = 32'd0;
            end
        endcase
    end

    // ------------------------------------------------------------
    // AXI Read Data
    // ------------------------------------------------------------
    always @(posedge S_AXI_ACLK) begin
        if (S_AXI_ARESETN == 1'b0) begin
            axi_rdata <= 0;
        end else begin
            if (slv_reg_rden) begin
                axi_rdata <= reg_data_out;
            end
        end
    end

endmodule
