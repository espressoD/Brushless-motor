module bldc_controller (
    input wire clk,
    input wire reset,
    input wire [7:0] speed_set,
    input wire [2:0] hall_signal,
    input wire current_overload,
    input wire no_feedback,
    output wire pwm_a, pwm_b, pwm_c,
    output wire fault
);

    // Internal Signals
    wire [7:0] pwm_a_out, pwm_b_out, pwm_c_out;
    wire [7:0] fsm_pwm_a, fsm_pwm_b, fsm_pwm_c;
    wire [7:0] olc_pwm_a, olc_pwm_b, olc_pwm_c;
    wire motor_enable;
    wire fault_signal;
    wire vdd = 1'b1;
    wire gnd = 1'b0;

    // === FSM Controller ===
    (* keep = "true" *) bldc_fsm_controller fsm_inst (
        .clk(clk),
        .reset(reset),
        .fault(fault_signal),
        .hall_signal(hall_signal),
        .speed_set(speed_set),
        .pwm_a(fsm_pwm_a),
        .pwm_b(fsm_pwm_b),
        .pwm_c(fsm_pwm_c),
        .motor_enable(motor_enable)
    );

    // === Fault Detection ===
    (* keep = "true" *) fault_detection fault_det (
        .clk(clk),
        .gnd(gnd),
        .vdd(vdd),
        .reset(reset),
        .current_overload(current_overload),
        .no_feedback(no_feedback),
        .fault(fault_signal)
    );

    // === PWM Generators ===
    (* keep = "true" *) pwm_generator pwm_a_gen (
        .clk(clk),
        .reset(reset),
        .duty_cycle(speed_set),
        .pwm_out(pwm_a_out)
    );

    (* keep = "true" *) pwm_generator pwm_b_gen (
        .clk(clk),
        .reset(reset),
        .duty_cycle(speed_set),
        .pwm_out(pwm_b_out)
    );

    (* keep = "true" *) pwm_generator pwm_c_gen (
        .clk(clk),
        .reset(reset),
        .duty_cycle(speed_set),
        .pwm_out(pwm_c_out)
    );

    // === Open Loop Controller ===
    (* keep = "true" *) open_loop_controller open_loop (
        .clk(clk),
        .reset(reset),
        .hall_signal(hall_signal),
        .speed_set(speed_set),
        .pwm_a(olc_pwm_a),
        .pwm_b(olc_pwm_b),
        .pwm_c(olc_pwm_c)
    );

    // === Output Assignment ===
    assign pwm_a = motor_enable ? fsm_pwm_a[0] : (pwm_a_out[0] | olc_pwm_a[0]);
    assign pwm_b = motor_enable ? fsm_pwm_b[0] : (pwm_b_out[0] | olc_pwm_b[0]);
    assign pwm_c = motor_enable ? fsm_pwm_c[0] : (pwm_c_out[0] | olc_pwm_c[0]);
    assign fault = fault_signal;

    // Prevent Optimization
    wire unused_signals;
    assign unused_signals = ^fsm_pwm_a | ^fsm_pwm_b | ^fsm_pwm_c | ^olc_pwm_a | ^olc_pwm_b | ^olc_pwm_c;

endmodule
