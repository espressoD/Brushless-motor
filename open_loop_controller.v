module open_loop_controller (
    input wire clk,                  // Clock input
    input wire reset,                // Reset input
    input wire [2:0] hall_signal,    // Hall sensor signal
    input wire [7:0] speed_set,      // Set speed for motor
    output reg [7:0] pwm_a, pwm_b, pwm_c // PWM signals for the phases
);

    reg [7:0] duty_cycle;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pwm_a <= 8'b0;
            pwm_b <= 8'b0;
            pwm_c <= 8'b0;
        end else begin
            duty_cycle <= speed_set;
            case (hall_signal)
                3'b001: begin
                    pwm_a <= duty_cycle; pwm_b <= 8'b0; pwm_c <= 8'b0;
                end
                3'b011: begin
                    pwm_a <= 8'b0; pwm_b <= duty_cycle; pwm_c <= 8'b0;
                end
                3'b010: begin
                    pwm_a <= 8'b0; pwm_b <= 8'b0; pwm_c <= duty_cycle;
                end
                default: begin
                    pwm_a <= 8'b0; pwm_b <= 8'b0; pwm_c <= 8'b0;
                end
            endcase
        end
    end

    // Prevent Optimization
    wire unused_duty_cycle;
    assign unused_duty_cycle = ^duty_cycle;

endmodule
