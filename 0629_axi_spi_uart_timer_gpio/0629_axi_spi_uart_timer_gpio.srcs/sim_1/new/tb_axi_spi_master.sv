`timescale 1ns / 1ps

module tb_axi_spi_master;

    // =========================================================
    // Clock / Reset
    // =========================================================
    reg s00_axi_aclk;
    reg s00_axi_aresetn;

    // =========================================================
    // AXI4-Lite Write Address Channel
    // =========================================================
    reg  [4:0]  s00_axi_awaddr;
    reg         s00_axi_awvalid;
    wire        s00_axi_awready;

    // =========================================================
    // AXI4-Lite Write Data Channel
    // =========================================================
    reg  [31:0] s00_axi_wdata;
    reg  [3:0]  s00_axi_wstrb;
    reg         s00_axi_wvalid;
    wire        s00_axi_wready;

    // =========================================================
    // AXI4-Lite Write Response Channel
    // =========================================================
    wire [1:0]  s00_axi_bresp;
    wire        s00_axi_bvalid;
    reg         s00_axi_bready;

    // =========================================================
    // AXI4-Lite Read Address Channel
    // =========================================================
    reg  [4:0]  s00_axi_araddr;
    reg         s00_axi_arvalid;
    wire        s00_axi_arready;

    // =========================================================
    // AXI4-Lite Read Data Channel
    // =========================================================
    wire [31:0] s00_axi_rdata;
    wire [1:0]  s00_axi_rresp;
    wire        s00_axi_rvalid;
    reg         s00_axi_rready;

    // =========================================================
    // SPI
    // =========================================================
    wire spi_sclk;
    wire spi_mosi;
    reg  spi_miso;
    wire spi_ss_n;
    wire spi_irq;
    
        // =========================================================
    // Simple SPI Slave Model
    // MISO response = 0x3C
    // =========================================================
    reg [7:0] miso_shift;
    integer miso_bit;

    // =========================================================
    // DUT
    // =========================================================
    axi_spi_master_v1_0 dut (
        .spi_sclk       (spi_sclk),
        .spi_mosi       (spi_mosi),
        .spi_miso       (spi_miso),
        .spi_ss_n       (spi_ss_n),
        .spi_irq        (spi_irq),

        .s00_axi_aclk   (s00_axi_aclk),
        .s00_axi_aresetn(s00_axi_aresetn),

        .s00_axi_awaddr (s00_axi_awaddr),
        .s00_axi_awprot (3'b000),
        .s00_axi_awvalid(s00_axi_awvalid),
        .s00_axi_awready(s00_axi_awready),

        .s00_axi_wdata  (s00_axi_wdata),
        .s00_axi_wstrb  (s00_axi_wstrb),
        .s00_axi_wvalid (s00_axi_wvalid),
        .s00_axi_wready (s00_axi_wready),

        .s00_axi_bresp  (s00_axi_bresp),
        .s00_axi_bvalid (s00_axi_bvalid),
        .s00_axi_bready (s00_axi_bready),

        .s00_axi_araddr (s00_axi_araddr),
        .s00_axi_arprot (3'b000),
        .s00_axi_arvalid(s00_axi_arvalid),
        .s00_axi_arready(s00_axi_arready),

        .s00_axi_rdata  (s00_axi_rdata),
        .s00_axi_rresp  (s00_axi_rresp),
        .s00_axi_rvalid (s00_axi_rvalid),
        .s00_axi_rready (s00_axi_rready)
    );


    // =========================================================
// Simple SPI Slave Response
// Mode 0 : Master samples MISO at rising edge
// Slave changes MISO at falling edge
//
// Response data : 0x3C = 0011_1100
// =========================================================
initial begin
    miso_shift = 8'h3C;
    miso_bit   = 7;
    spi_miso   = 1'b0;
end

// CS가 Low가 되면 첫 번째 bit(bit7)를 미리 준비
always @(negedge spi_ss_n) begin
    miso_bit = 7;
    spi_miso = miso_shift[7];
end

// SCLK falling edge마다 다음 bit 준비
always @(negedge spi_sclk) begin
    if (!spi_ss_n && miso_bit > 0) begin
        miso_bit = miso_bit - 1;
        spi_miso = miso_shift[miso_bit];
    end
end

    // =========================================================
    // 100 MHz Clock
    // =========================================================
    initial begin
        s00_axi_aclk = 0;

        forever #5 s00_axi_aclk = ~s00_axi_aclk;
    end


    // =========================================================
    // AXI Write Task
    // =========================================================
    task axi_write(
        input [4:0] addr,
        input [31:0] data
    );
    begin

        @(posedge s00_axi_aclk);

        s00_axi_awaddr  <= addr;
        s00_axi_awvalid <= 1'b1;

        s00_axi_wdata   <= data;
        s00_axi_wstrb   <= 4'b1111;
        s00_axi_wvalid  <= 1'b1;

        s00_axi_bready  <= 1'b1;


        // Address + Data handshake
        wait(s00_axi_awready && s00_axi_wready);

        @(posedge s00_axi_aclk);

        s00_axi_awvalid <= 1'b0;
        s00_axi_wvalid  <= 1'b0;


        // Write response
        wait(s00_axi_bvalid);

        @(posedge s00_axi_aclk);

        s00_axi_bready <= 1'b0;

    end
    endtask


    // =========================================================
    // AXI Read Task
    // =========================================================
    task axi_read(
        input [4:0] addr
    );
    begin

        @(posedge s00_axi_aclk);

        s00_axi_araddr  <= addr;
        s00_axi_arvalid <= 1'b1;
        s00_axi_rready  <= 1'b1;


        wait(s00_axi_arready);

        @(posedge s00_axi_aclk);

        s00_axi_arvalid <= 1'b0;


        wait(s00_axi_rvalid);

        $display(
            "TIME=%0t ADDR=0x%02h DATA=0x%08h",
            $time,
            addr,
            s00_axi_rdata
        );

        @(posedge s00_axi_aclk);

        s00_axi_rready <= 1'b0;

    end
    endtask


    // =========================================================
    // Test Sequence
    // =========================================================
    initial begin

        // 초기값
        s00_axi_aresetn = 0;

        s00_axi_awaddr  = 0;
        s00_axi_awvalid = 0;

        s00_axi_wdata   = 0;
        s00_axi_wstrb   = 0;
        s00_axi_wvalid  = 0;

        s00_axi_bready  = 0;

        s00_axi_araddr  = 0;
        s00_axi_arvalid = 0;

        s00_axi_rready  = 0;



        // RESET
        #100;

        s00_axi_aresetn = 1;

        #50;


        // -----------------------------------------------------
        // 0x08 SPI_CLKDIV = 10
        // -----------------------------------------------------
        axi_write(5'h08, 32'd10);


        // -----------------------------------------------------
        // 0x0C SPI_TX = 0xA5
        // -----------------------------------------------------
        axi_write(5'h0C, 32'h000000A5);


        // -----------------------------------------------------
        // 0x00 SPI_CTRL
        // START = 1
        // CPOL  = 0
        // CPHA  = 0
        // -----------------------------------------------------
        axi_write(5'h00, 32'h00000001);


        // SPI가 충분히 동작할 시간
        #5000;


        // -----------------------------------------------------
        // STATUS Read
        // -----------------------------------------------------
        axi_read(5'h04);


        // -----------------------------------------------------
        // RX Read
        // -----------------------------------------------------
        axi_read(5'h10);


        #100;

        $finish;

    end

endmodule