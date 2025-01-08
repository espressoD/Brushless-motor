library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity bldc_controller is
    Port (
        clk : in std_logic;
        reset : in std_logic;
        speed_set : in std_logic_vector(7 downto 0);
        hall_signal : in std_logic_vector(2 downto 0);
        current_overload : in std_logic; -- Harus ada
        no_feedback : in std_logic; -- Harus ada
        pwm_a : out std_logic;
        pwm_b : out std_logic;
        pwm_c : out std_logic;
        fault : out std_logic -- Harus ada
    );
end bldc_controller;


architecture Behavioral of bldc_controller is
    signal fsm_pwm_a, fsm_pwm_b, fsm_pwm_c : std_logic;
    signal pwm_a_duty, pwm_b_duty, pwm_c_duty : std_logic;

begin
    fsm_inst: entity work.bldc_fsm_controller
        port map (
            clk => clk,
            reset => reset,
            hall_signal => hall_signal,
            speed_set => speed_set,
            pwm_a => fsm_pwm_a,
            pwm_b => fsm_pwm_b,
            pwm_c => fsm_pwm_c
        );
        -- Instance Fault Detection
    fault_inst : entity work.fault_detection
        port map (
            current_overload => current_overload,
            no_feedback => no_feedback,
            fault => fault
        );

    pwm_a_gen: entity work.pwm_generator
        port map (
            clk => clk,
            reset => reset,
            duty_cycle => speed_set,
            pwm_out => pwm_a_duty
        );

    pwm_b_gen: entity work.pwm_generator
        port map (
            clk => clk,
            reset => reset,
            duty_cycle => speed_set,
            pwm_out => pwm_b_duty
        );

    pwm_c_gen: entity work.pwm_generator
        port map (
            clk => clk,
            reset => reset,
            duty_cycle => speed_set,
            pwm_out => pwm_c_duty
        );

    -- Output Multiplexing
    pwm_a <= fsm_pwm_a and pwm_a_duty;
    pwm_b <= fsm_pwm_b and pwm_b_duty;
    pwm_c <= fsm_pwm_c and pwm_c_duty;

end Behavioral;

