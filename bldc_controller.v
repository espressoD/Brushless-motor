module bldc_controller (
    input wire clk,
    input wire reset,
    input wire [2:0] hall_sensors,
    input wire [7:0] duty,
    output wire pwm_a,
    output wire pwm_b,
    output wire pwm_c
);
    wire phase_a, phase_b, phase_c;
    wire pwm_signal_a, pwm_signal_b, pwm_signal_c;

    // Instantiate PWM Generators
    pwm_generator pwm_gen_a (
        .clk(clk),
        .reset(reset),
        .duty(duty),
        .pwm_out(pwm_signal_a)
    );

    pwm_generator pwm_gen_b (
        .clk(clk),
        .reset(reset),
        .duty(duty),
        .pwm_out(pwm_signal_b)
    );

    pwm_generator pwm_gen_c (
        .clk(clk),
        .reset(reset),
        .duty(duty),
        .pwm_out(pwm_signal_c)
    );

    // Instantiate Commutation Logic
    commutation comm_logic (
        .hall_sensors(hall_sensors),
        .phase_a(phase_a),
        .phase_b(phase_b),
        .phase_c(phase_c)
    );

    // Combine PWM with Commutation
    assign pwm_a = pwm_signal_a & phase_a;
    assign pwm_b = pwm_signal_b & phase_b;
    assign pwm_c = pwm_signal_c & phase_c;

endmodule
