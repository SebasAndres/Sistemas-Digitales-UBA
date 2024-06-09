module register (
    input logic rst,
    input logic clk,
    input logic en_write,
    input logic [7:0] data_in,
    output logic [7:0] data_out
);

logic [7:0] data;

always_ff @ (posedge clk or posedge rst) begin
    if (rst) begin
        data <= '0;
    end else begin
        if (en_write) data <= data_in;
    end
end

assign data_out = data;

initial begin
    data = 0;
    $dumpfile("register.vcd");
    $dumpvars(0, register);
end

endmodule
