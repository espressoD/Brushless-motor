library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity open_loop_controller is
    Port (
        hall_signal : in std_logic_vector(2 downto 0);
        speed_set   : in std_logic_vector(7 downto 0);
        pwm_a       : out std_logic_vector(7 downto 0);
        pwm_b       : out std_logic_vector(7 downto 0);
        pwm_c       : out std_logic_vector(7 downto 0)
    );
end open_loop_controller;

architecture Behavioral of open_loop_controller is
begin
    pwm_a <= speed_set;
    pwm_b <= speed_set;
    pwm_c <= speed_set;
end Behavioral;

