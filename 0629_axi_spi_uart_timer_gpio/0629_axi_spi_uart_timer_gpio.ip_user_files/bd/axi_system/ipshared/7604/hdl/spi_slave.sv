`timescale 1ns / 1ps

module spi_slave (
    input  logic       clk,
    input  logic       reset,

    input  logic       sclk,
    input  logic       mosi,
    output logic       miso,
    input  logic       ss_n,

    input  logic [7:0] tx_data,
    output logic [7:0] rx_data,
    output logic       done
);

    logic sclk_d;
    logic ss_n_d;
    logic mosi_d;

    logic [7:0] rx_shift;
    logic [7:0] tx_shift;
    logic [2:0] bit_cnt;

    wire sclk_rise;
    wire sclk_fall;
    wire ss_fall;
    wire ss_high;

    assign sclk_rise = (sclk_d == 1'b0) && (sclk == 1'b1);
    assign sclk_fall = (sclk_d == 1'b1) && (sclk == 1'b0);
    assign ss_fall   = (ss_n_d == 1'b1) && (ss_n == 1'b0);
    assign ss_high   = ss_n;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            sclk_d <= 1'b0;
            ss_n_d <= 1'b1;
            mosi_d <= 1'b0;
        end else begin
            sclk_d <= sclk;
            ss_n_d <= ss_n;
            mosi_d <= mosi;
        end
    end

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            rx_shift <= 8'd0;
            tx_shift <= 8'd0;
            rx_data  <= 8'd0;
            bit_cnt  <= 3'd0;
            miso     <= 1'b0;
            done     <= 1'b0;
        end else begin
            done <= 1'b0;

            if (ss_high) begin
                bit_cnt <= 3'd0;
                miso    <= 1'b0;
            end else begin
                if (ss_fall) begin
                    tx_shift <= tx_data;
                    rx_shift <= 8'd0;
                    bit_cnt  <= 3'd0;
                    miso     <= tx_data[7];
                end

                // SPI mode 0 기준: rising edge에서 MOSI sample
                if (sclk_rise) begin
                    rx_shift <= {rx_shift[6:0], mosi_d};

                    if (bit_cnt == 3'd7) begin
                        rx_data <= {rx_shift[6:0], mosi_d};
                        done    <= 1'b1;
                    end else begin
                        bit_cnt <= bit_cnt + 3'd1;
                    end
                end

                // falling edge에서 다음 MISO 준비
                if (sclk_fall) begin
                    tx_shift <= {tx_shift[6:0], 1'b0};
                    miso     <= tx_shift[6];
                end
            end
        end
    end

endmodule
