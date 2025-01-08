library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fault_detection is
    Port (
        current_overload : in std_logic;
        no_feedback      : in std_logic;
        fault            : out std_logic
    );
end fault_detection;

architecture Behavioral of fault_detection is
begin
    process(current_overload, no_feedback)
    begin
        if current_overload = '1' or no_feedback = '1' then
            fault <= '1';
        else
            fault <= '0';
        end if;
    end process;
end Behavioral;

