library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity bldc_fsm_controller is
    Port (
        clk : in std_logic;
        reset : in std_logic;
        hall_signal : in std_logic_vector(2 downto 0);
        speed_set : in std_logic_vector(7 downto 0);
        pwm_a : out std_logic;
        pwm_b : out std_logic;
        pwm_c : out std_logic
    );
end bldc_fsm_controller;

architecture Behavioral of bldc_fsm_controller is
begin
    process(clk, reset)
    begin
        if reset = '1' then
            pwm_a <= '0';
            pwm_b <= '0';
            pwm_c <= '0';
        elsif rising_edge(clk) then
            case hall_signal is
                when "001" => -- Phase Sequence 1
                    pwm_a <= '0';
                    pwm_b <= '0';
                    pwm_c <= '1';
                when "011" => -- Phase Sequence 2
                    pwm_a <= '0';
                    pwm_b <= '1';
                    pwm_c <= '1';
                when "010" => -- Phase Sequence 3
                    pwm_a <= '0';
                    pwm_b <= '1';
                    pwm_c <= '0';
                when "110" => -- Phase Sequence 4
                    pwm_a <= '1';
                    pwm_b <= '1';
                    pwm_c <= '0';
                when "100" => -- Phase Sequence 5
                    pwm_a <= '1';
                    pwm_b <= '0';
                    pwm_c <= '0';
                when "101" => -- Phase Sequence 6
                    pwm_a <= '1';
                    pwm_b <= '0';
                    pwm_c <= '1';
		when "111" => -- Phase Sequence 6
                    pwm_a <= '1';
                    pwm_b <= '1';
                    pwm_c <= '1';
                when others =>
                    pwm_a <= '0';
                    pwm_b <= '0';
                    pwm_c <= '0';
            end case;
        end if;
    end process;
end Behavioral;

