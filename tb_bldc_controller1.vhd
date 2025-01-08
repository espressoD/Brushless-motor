library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_bldc_controller1 is
end tb_bldc_controller1;

architecture behavior of tb_bldc_controller1 is
    -- Deklarasi sinyal uji coba
    signal clk            : std_logic := '0';
    signal reset          : std_logic := '1';
    signal speed_set      : std_logic_vector(7 downto 0) := (others => '0');
    signal hall_signal    : std_logic_vector(2 downto 0) := (others => '0');
    signal current_overload : std_logic := '0';
    signal no_feedback    : std_logic := '0';
    signal pwm_a          : std_logic := '0';
    signal pwm_b          : std_logic := '0';
    signal pwm_c          : std_logic := '0';
    signal fault          : std_logic := '0';

    -- Clock period definition
    constant clk_period : time := 10 ns;

begin
    -- Instansiasi DUT (Device Under Test)
    uut: entity work.bldc_controller
        port map (
            clk => clk,
            reset => reset,
            speed_set => speed_set,
            hall_signal => hall_signal,
            current_overload => current_overload,
            no_feedback => no_feedback,
            pwm_a => pwm_a,
            pwm_b => pwm_b,
            pwm_c => pwm_c,
            fault => fault
        );

    -- Proses Clock
    clk_process : process
    begin
        while now < 5000 ns loop
            clk <= not clk;
            wait for clk_period / 2;
        end loop;
        wait;
    end process;

    -- Proses Stimulus
    stimulus_process : process
    begin
        -- Reset Sistem
        report "Reset System" severity note;
        reset <= '1';
        wait for 20 ns;
        reset <= '0';
        wait for 50 ns;

        -- Test Case 1: Operasi Normal dengan speed_set dan hall_signal
        report "Test Case 1: Normal Operation" severity note;
        speed_set <= "10101010";
        hall_signal <= "011";
        wait for 100 ns;

        -- Test Case 2: Fault Detection (Current Overload)
        report "Test Case 2: Fault Detection - Current Overload" severity note;
        current_overload <= '1';
        wait for 50 ns;
        assert (fault = '1') report "Fault signal not set during current overload!" severity error;
        current_overload <= '0';
        wait for 50 ns;
        assert (fault = '0') report "Fault signal did not reset correctly!" severity error;

        -- Test Case 3: Fault Detection (No Feedback)
        report "Test Case 3: Fault Detection - No Feedback" severity note;
        no_feedback <= '1';
        wait for 50 ns;
        assert (fault = '1') report "Fault signal not set during no feedback!" severity error;
        no_feedback <= '0';
        wait for 50 ns;
        assert (fault = '0') report "Fault signal did not reset correctly!" severity error;

        -- Test Case 4: PWM Generator Test with Different speed_set and hall_signal
        report "Test Case 4: PWM Generator Test with hall_signal and speed_set" severity note;

        -- Kondisi 1: speed_set rendah, hall_signal 001
        speed_set <= "00001111";
        hall_signal <= "001";
        wait for 100 ns;
        assert (pwm_a /= '0' and pwm_b /= '0' and pwm_c /= '0') 
            report "PWM Generator failed for hall_signal=001 and speed_set=00001111" severity error;

        -- Kondisi 2: speed_set sedang, hall_signal 010
        speed_set <= "01111111";
        hall_signal <= "010";
        wait for 100 ns;
        assert (pwm_a /= '0' and pwm_b /= '0' and pwm_c /= '0') 
            report "PWM Generator failed for hall_signal=010 and speed_set=01111111" severity error;

        -- Kondisi 3: speed_set tinggi, hall_signal 110
        speed_set <= "11111111";
        hall_signal <= "110";
        wait for 100 ns;
        assert (pwm_a /= '0' and pwm_b /= '0' and pwm_c /= '0') 
            report "PWM Generator failed for hall_signal=110 and speed_set=11111111" severity error;

        -- Test Case 5: Open Loop Control Test
        report "Test Case 5: Open Loop Control Test" severity note;
        hall_signal <= "101";
        speed_set <= "11001100";
        wait for 100 ns;

        -- Test Case 6: Invalid State Recovery
        report "Test Case 6: Invalid State Recovery" severity note;
        reset <= '1';
        wait for 30 ns;
        reset <= '0';
        wait for 100 ns;
        -- Test Case 7: Hall Signal Mapping Test
	report "Test Case 7: Hall Signal Mapping Test" severity note;
	hall_signal <= "001";
	speed_set <= "10011001";
	wait for 100 ns;

	hall_signal <= "010";
	speed_set <= "11001100";
	wait for 100 ns;

	hall_signal <= "011";
	speed_set <= "11110000";
	wait for 100 ns;

	-- Test Case 8: PWM Duty Cycle Adjustment
	report "Test Case 8: PWM Duty Cycle Adjustment" severity note;
	speed_set <= "00001111"; -- 15% Duty Cycle
	wait for 100 ns;

	speed_set <= "11111111"; -- 100% Duty Cycle
	wait for 100 ns;
	-- Test Case 9: Hall Signal and PWM Synchronization
report "Test Case 9: Hall Signal and PWM Synchronization" severity note;
hall_signal <= "001";
speed_set <= "01100110"; -- 50% Duty Cycle
wait for 100 ns;

hall_signal <= "010";
speed_set <= "10101010"; -- 75% Duty Cycle
wait for 100 ns;

hall_signal <= "011";
speed_set <= "11110000"; -- 100% Duty Cycle
wait for 100 ns;


        -- Akhiri Simulasi
        report "Simulation Completed Successfully" severity note;
        wait;
    end process;

    -- Proses Monitoring
    monitor_process : process
    begin
        while now < 1000 ns loop
            report "PWM_A: " & std_logic'image(pwm_a) severity note;
            report "PWM_B: " & std_logic'image(pwm_b) severity note;
            report "PWM_C: " & std_logic'image(pwm_c) severity note;
            report "FAULT: " & std_logic'image(fault) severity note;
            wait for 50 ns;
        end loop;
        wait;
    end process;

end behavior;

