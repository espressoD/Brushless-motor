module commutation (
    input wire [2:0] hall_sensors, // Hall sensor inputs
    output reg phase_a,
    output reg phase_b,
    output reg phase_c
);
    always @(*) begin
        case (hall_sensors)
            3'b001: begin phase_a = 1; phase_b = 0; phase_c = 1; end // Step 1
            3'b010: begin phase_a = 1; phase_b = 1; phase_c = 0; end // Step 2
            3'b011: begin phase_a = 0; phase_b = 1; phase_c = 1; end // Step 3
            3'b100: begin phase_a = 0; phase_b = 1; phase_c = 0; end // Step 4
            3'b101: begin phase_a = 1; phase_b = 0; phase_c = 0; end // Step 5
            3'b110: begin phase_a = 1; phase_b = 1; phase_c = 0; end // Step 6
            default: begin phase_a = 0; phase_b = 0; phase_c = 0; end // Fault state
        endcase
    end
endmodule
