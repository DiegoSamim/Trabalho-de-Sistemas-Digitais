library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity count_display_with_alu is
    port (
        CLOCK_50    : in  std_logic;
        G_HEX0      : out std_logic_vector(6 downto 0);
        alu_op      : out std_logic_vector(3 downto 0)
    );
end count_display_with_alu;

architecture structural of count_display_with_alu is
    signal counter    : unsigned(3 downto 0) := "0000";
    signal op         : std_logic_vector(3 downto 0) := "0000";

    component counter_seconds is
        port (
            CLOCK_50    : in  std_logic;
            counter_out : out unsigned(3 downto 0)
        );
    end component;

    component decoder7seg is
        port (
            bcd_in          : in  unsigned(3 downto 0);
            seven_seg_out   : out std_logic_vector(6 downto 0)
        );
    end component;

begin
    counter0: counter_seconds port map(CLOCK_50, counter);
    decoder0: decoder7seg port map(counter, G_HEX0);

    process(counter)
    begin
        case counter is
            when "0000" => op <= "0000";  -- Operação 0 (por exemplo, NOP - sem operação)
            when "0001" => op <= "0001";  -- Operação 1 (por exemplo, ADD - adição)
            when "0010" => op <= "0010";  -- Operação 2 (por exemplo, SUB - subtração)
            when "0011" => op <= "0100";  -- Operação 4 (por exemplo, AND - operação lógica AND)
            when "0100" => op <= "0101";  -- Operação 5 (por exemplo, OR - operação lógica OR)
            when "0101" => op <= "0110";  -- Operação 6 (por exemplo, XOR - operação lógica XOR)
            when "0110" => op <= "0111";  -- Operação 7 (por exemplo, XNOR - operação lógica XNOR)
            when others => op <= "0000";  -- Caso contrário, definir para operação 0 (NOP)
        end case;
    end process;

    alu_op <= op;

end structural;
