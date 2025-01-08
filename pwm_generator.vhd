library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity pwm_generator is
    Port (
        clk : in std_logic;
        reset : in std_logic;
        duty_cycle : in std_logic_vector(7 downto 0);
        pwm_out : out std_logic
    );
end pwm_generator;

architecture Behavioral of pwm_generator is
    signal pwm_counter : unsigned(7 downto 0) := (others => '0');
begin
    process(clk, reset)
    begin
        if reset = '1' then
            pwm_counter <= (others => '0');
            pwm_out <= '0';
        elsif rising_edge(clk) then
            pwm_counter <= pwm_counter + 1;
            if pwm_counter < unsigned(duty_cycle) then
                pwm_out <= '1';
            else
                pwm_out <= '0';
            end if;
        end if;
    end process;
end Behavioral;

