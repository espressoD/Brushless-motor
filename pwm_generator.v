module pwm_generator (
    input wire clk,
    input wire reset,
    input wire [7:0] duty, // Duty cycle (0-255)
    output reg pwm_out
);
    reg [7:0] counter;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 8'b0;
            pwm_out <= 1'b0;
        end else begin
            counter <= counter + 1;
            pwm_out <= (counter < duty) ? 1'b1 : 1'b0;
        end
    end
endmodule
