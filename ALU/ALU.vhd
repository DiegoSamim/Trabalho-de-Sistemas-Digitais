library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is
    port (
        a, b         : in  unsigned(3 downto 0);      -- Entradas de 4 bits (operandos)
        cin          : in  std_logic;                 -- Carry in
        op           : in  std_logic_vector(3 downto 0);  -- Operação
        f            : out unsigned(3 downto 0);      -- Saída de 4 bits
        z, c_out     : out std_logic;                 -- Zero e carry out
        negative_out : out std_logic;                 -- Flag para indicar saída negativa
        overflow_out : out std_logic                  -- Flag para indicar overflow
    );
end entity ALU;

architecture structural of ALU is

    signal a_tmp, b_tmp, f_tmp :   unsigned(4 downto 0);  -- Sinais temporários de 5 bits (um bit extra)
    
begin

    a_tmp <= '0' & a;   		   -- Entrada a + 1
    b_tmp <= '0' & b;   		   -- Entrada b + 1
    f <= f_tmp(3 downto 0);    -- Resultado (4 bits)
    c_out <= f_tmp(4);   	   -- Carry out (bit mais significativo)
    
    ALU: process(a_tmp, b_tmp, cin, op) is
        variable tmp_result : signed(4 downto 0);
    begin
        tmp_result := signed(a_tmp) - signed(b_tmp);

        case op is
            -- operações aritméticas
            when "0000" =>  -- Adição
                if cin = '1' then
                    tmp_result := signed(a_tmp) + signed(b_tmp) + "00001"; -- Adiciona o carry in
                else
                    tmp_result := signed(a_tmp) + signed(b_tmp);
                end if;
            when "0001" =>  -- SUBtração
                if cin = '1' then
                    tmp_result := signed(a_tmp) - signed(b_tmp) - "00001"; -- Subtrai o carry in
                else
                    tmp_result := signed(a_tmp) - signed(b_tmp);
                end if;
            when "0010" =>  -- Acrescentar 1 à entrada A
                tmp_result := signed(a_tmp) + 1;
            when "0011" =>  -- Inverter A (NOTA)
                tmp_result := not signed(a_tmp);

            -- operações lógicas
			when "0100" => tmp_result := signed(a_tmp) and signed(b_tmp);	    -- AND
			when "0101" => tmp_result := signed(a_tmp) or signed(b_tmp);		-- OR
			when "0110" => tmp_result := signed(a_tmp) xor signed(b_tmp);	    -- XOR
			when "0111" => tmp_result := signed(a_tmp) xnor signed(b_tmp);	-- XNOR
			
            when others => tmp_result := (others => '0');
        end case;
        
        f_tmp <= unsigned(tmp_result);

    end process ALU;

    zero: process(f_tmp) is
        variable zero   :   std_logic;
    begin
        for i in 3 downto 0 loop
            if f_tmp(i) = '1' then 
                zero := '0';
                exit;
            else
                zero := '1';
            end if;
        end loop;
        z <= zero;
    end process zero;
    
    -- Verifica se a saída é negativa
    negative_out <= '1' when f_tmp(3) = '1' else '0';
    
    -- Verifica se ocorreu um overflow
    overflow_out <= '1' when f_tmp(4) /= f_tmp(3) else '0';
    
end architecture structural;
