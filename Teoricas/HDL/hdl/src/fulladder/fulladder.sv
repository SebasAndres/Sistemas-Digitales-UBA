module fulladder (
    input logic a,
    input logic b,
    input logic cin,
    output logic s,
    output logic cout
);

logic p, g;

always_comb begin
    p = a ^ b;
    g = a & b;
    s = p ^ cin;
    cout = g | (p & cin);
end

initial begin
    $dumpfile("fulladder.vcd");
    $dumpvars(0, fulladder);
end

endmodule
