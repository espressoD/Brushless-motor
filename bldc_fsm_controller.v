module bldc_fsm_controller (
    input wire clk,
    input wire reset,
    input wire fault,
    input wire [2:0] hall_signal,
    input wire [7:0] speed_set,
    output reg [7:0] pwm_a, pwm_b, pwm_c,
    output reg motor_enable
);

    parameter IDLE = 2'b00;
    parameter RUN = 2'b01;
    parameter FAULT_STATE = 2'b10;

    reg [1:0] current_state, next_state;

    always @(posedge clk or posedge reset) begin
        if (reset)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end

    always @(*) begin
        case (current_state)
            IDLE: next_state = (fault) ? FAULT_STATE : RUN;
            RUN: next_state = (fault) ? FAULT_STATE : RUN;
            FAULT_STATE: next_state = (reset) ? IDLE : FAULT_STATE;
            default: next_state = IDLE;
        endcase
    end

    always @(posedge clk) begin
        case (current_state)
            IDLE: begin
                pwm_a <= 8'b0;
                pwm_b <= 8'b0;
                pwm_c <= 8'b0;
                motor_enable <= 1'b0;
            end
            RUN: begin
                motor_enable <= 1'b1;
                case (hall_signal)
                    3'b001: pwm_a <= speed_set;
                    3'b011: pwm_b <= speed_set;
                    3'b010: pwm_c <= speed_set;
                    default: begin pwm_a <= 8'b0; pwm_b <= 8'b0; pwm_c <= 8'b0; end
                endcase
            end
            FAULT_STATE: begin
                pwm_a <= 8'b0;
                pwm_b <= 8'b0;
                pwm_c <= 8'b0;
                motor_enable <= 1'b0;
            end
        endcase
    end

endmodule
