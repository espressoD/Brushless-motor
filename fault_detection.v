module fault_detection (
    input wire clk,
    input wire gnd,
    input wire vdd,
    input wire reset,
    input wire current_overload,
    input wire no_feedback,
    output reg fault
);

    always @(posedge clk or posedge reset) begin
        if (reset)
            fault <= 1'b0;  // Reset fault signal
        else if (current_overload || no_feedback)
            fault <= 1'b1;  // Fault detected
        else
            fault <= 1'b0;  // No fault detected
    end

endmodule
