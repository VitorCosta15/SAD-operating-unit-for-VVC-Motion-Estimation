library IEEE;
use IEEE.STD_LOGIC_1164.all;
USE ieee.std_logic_unsigned.ALL;
USE IEEE.std_logic_arith.all;
package ME_types is

	constant paralelismo: integer := 16; --16, 32 ou 64
	constant usarBuffer: integer := 0; --deve utilizar buffer se a memoria entregar menos dados do que a arquitetura precisa.
	constant delayComp : integer := 14;
	constant pipelineDoSqrdSAD: integer := 4;

	type array_1d_2_11bits is array(1 to 2) of std_logic_vector(10 downto 0);
  	type array_1d_4_8bits is array(1 to 4) of std_logic_vector(7 downto 0);
	type array_1d_4_10bits is array(1 to 4) of std_logic_vector(9 downto 0);
	type array_1d_8_9bits is array(1 to 8) of std_logic_vector(8 downto 0);
	type array_1d_16_9bits is array(1 to 16) of std_logic_vector(8 downto 0);
	type array_1d_16_8bits is array(1 to 16) of std_logic_vector(7 downto 0);

	type array_1d_64_8bits is array (1 to 64) of std_logic_vector(7 downto 0);
	type array_1d_72_8bits is array (1 to 72) of std_logic_vector(7 downto 0);

  	type array_2d_4x4_8bits is array (1 to 4) of array_1d_4_8bits;
  	type array_2d_4x64_8bits is array (1 to 4) of array_1d_64_8bits;
	type array_2d_16x64_8bits is array(1 to 16) of array_1d_64_8bits;

--Sinais que dependem do paralelismo

	type array_1d_P_12bits is array (1 to paralelismo) of std_logic_vector(11 downto 0);
	type array_1d_P_13bits is array (1 to paralelismo) of std_logic_vector(12 downto 0);
	type array_1d_P_14bits is array (1 to paralelismo) of std_logic_vector(13 downto 0);
	
	type array_1d_P2_12bits is array (1 to paralelismo/2) of std_logic_vector(11 downto 0);
	type array_1d_P2_13bits is array (1 to paralelismo/2) of std_logic_vector(12 downto 0);
	type array_1d_P2_14bits is array (1 to paralelismo/4) of std_logic_vector(13 downto 0);
	type array_1d_P2_15bits is array (1 to paralelismo/8) of std_logic_vector(14 downto 0); --4
	type array_1d_P2_16bits is array (1 to paralelismo/8) of std_logic_vector(15 downto 0); --4
	type array_1d_P4_15bits is array (1 to paralelismo/8) of std_logic_vector(14 downto 0); --4
	type array_1d_P4_16bits is array (1 to paralelismo/(paralelismo/4)) of std_logic_vector(15 downto 0);
	type array_1d_P4_17bits is array (1 to paralelismo/(paralelismo/4)) of std_logic_vector(16 downto 0);
	type array_1d_P8_17bits is array (1 to paralelismo/(paralelismo/2)) of std_logic_vector(16 downto 0);
	type array_1d_P8_18bits is array (1 to paralelismo/(paralelismo/2)) of std_logic_vector(17 downto 0);
	type array_1d_P8_19bits is array (1 to paralelismo/(paralelismo/2)) of std_logic_vector(18 downto 0);
	type array_1d_P16_19bits is array (1 to paralelismo/paralelismo) of std_logic_vector(18 downto 0);
	type array_1d_P16_20bits is array (1 to paralelismo/paralelismo) of std_logic_vector(19 downto 0);

	type array_1d_16_15bits is array (1 to 16) of std_logic_vector(14 downto 0);
	type array_1d_8_17bits is array (1 to 8) of std_logic_vector(16 downto 0);

	type array_3d_Px4x4_8bits is array (1 to paralelismo) of array_2d_4x4_8bits;

--Tabela de SADs
	type array_1d_1_20bits is array (1 to 1) of std_logic_vector(19 downto 0);
	type array_1d_2_19bits is array (1 to 2) of std_logic_vector(18 downto 0);
	type array_1d_1_19bits is array (1 to 1) of std_logic_vector(18 downto 0);
	type array_1d_2_18bits is array (1 to 2) of std_logic_vector(17 downto 0);
	type array_1d_4_17bits is array (1 to 4) of std_logic_vector(16 downto 0);
	type array_1d_2_17bits is array (1 to 2) of std_logic_vector(16 downto 0);
	type array_1d_4_16bits is array (1 to 4) of std_logic_vector(15 downto 0);
	type array_1d_8_15bits is array (1 to 8) of std_logic_vector(14 downto 0);
	type array_1d_4_15bits is array (1 to 4) of std_logic_vector(14 downto 0);
	type array_1d_16_14bits is array (1 to 16) of std_logic_vector(13 downto 0);
	type array_1d_8_14bits is array (1 to 8) of std_logic_vector(13 downto 0);
	type array_1d_4_14bits is array (1 to 4) of std_logic_vector(13 downto 0);
	type array_1d_2_14bits is array (1 to 2) of std_logic_vector(13 downto 0);
	type array_1d_1_14bits is array (1 to 1) of std_logic_vector(13 downto 0);
	type array_1d_16_13bits is array (1 to 16) of std_logic_vector(12 downto 0);
	type array_1d_8_13bits is array (1 to 8) of std_logic_vector(12 downto 0);
	type array_1d_16_12bits is array (1 to 16) of std_logic_vector(11 downto 0);
	type array_2d_1x1_20bits is array (1 to 1) of array_1d_1_20bits;
	type array_2d_1x2_19bits is array (1 to 1) of array_1d_2_19bits;
	type array_2d_2x1_19bits is array (1 to 2) of array_1d_1_19bits;
	type array_2d_2x2_18bits is array (1 to 2) of array_1d_2_18bits;
	type array_2d_2x4_17bits is array (1 to 2) of array_1d_4_17bits;
	type array_2d_4x2_17bits is array (1 to 4) of array_1d_2_17bits;
	type array_2d_4x4_16bits is array (1 to 4) of array_1d_4_16bits;
	type array_2d_4x8_15bits is array (1 to 4) of array_1d_8_15bits;
	type array_2d_8x4_15bits is array (1 to 8) of array_1d_4_15bits;
	type array_2d_8x8_14bits is array (1 to 8) of array_1d_8_14bits;
	type array_2d_8x16_13bits is array (1 to 8) of array_1d_16_13bits;
	type array_2d_16x8_13bits is array (1 to 16) of array_1d_8_13bits;
	type array_2d_16x16_12bits is array (1 to 16) of array_1d_16_12bits;
  	
	type array_2d_1x1_14bits is array (1 to 1) of array_1d_1_14bits;
	type array_2d_1x2_14bits is array (1 to 1) of array_1d_2_14bits;
	type array_2d_2x1_14bits is array (1 to 2) of array_1d_1_14bits;
	type array_2d_2x2_14bits is array (1 to 2) of array_1d_2_14bits;
	type array_2d_2x4_14bits is array (1 to 2) of array_1d_4_14bits;
	type array_2d_4x2_14bits is array (1 to 4) of array_1d_2_14bits;
	type array_2d_4x4_14bits is array (1 to 4) of array_1d_4_14bits;
	type array_2d_4x8_14bits is array (1 to 4) of array_1d_8_14bits;
	type array_2d_4x16_14bits is array (1 to 4) of array_1d_16_14bits;
	type array_2d_8x4_14bits is array (1 to 8) of array_1d_4_14bits;
	type array_2d_8x16_14bits is array (1 to 8) of array_1d_16_14bits;
	type array_2d_16x8_14bits is array (1 to 16) of array_1d_8_14bits;
	type array_2d_16x16_14bits is array (1 to 16) of array_1d_16_14bits;
	type array_2d_8x2_14bits is array (1 to 8) of array_1d_2_14bits;
	type array_2d_4x1_14bits is array (1 to 4) of array_1d_1_14bits;
	
	type array_1d_16_20bits is array (1 to 16) of std_logic_vector(19 downto 0);
	type array_1d_8_20bits is array (1 to 8) of std_logic_vector(19 downto 0);
	type array_1d_4_20bits is array (1 to 4) of std_logic_vector(19 downto 0);
	type array_1d_2_20bits is array (1 to 2) of std_logic_vector(19 downto 0);
	type array_1d_1_18bits is array (1 to 1) of std_logic_vector(17 downto 0);
	type array_1d_2_16bits is array (1 to 2) of std_logic_vector(15 downto 0);
	type array_1d_4_18bits is array (1 to 4) of std_logic_vector(17 downto 0);
	type array_1d_8_16bits is array (1 to 8) of std_logic_vector(15 downto 0);

	type array_2d_8x16_20bits is array (1 to 8) of array_1d_16_20bits;
	type array_2d_16x8_20bits is array (1 to 16) of array_1d_8_20bits;
	type array_2d_8x8_20bits is array (1 to 8) of array_1d_8_20bits;
	type array_2d_4x8_20bits is array (1 to 4) of array_1d_8_20bits;
	type array_2d_8x4_20bits is array (1 to 8) of array_1d_4_20bits;
	type array_2d_4x4_20bits is array (1 to 4) of array_1d_4_20bits;
	type array_2d_2x4_20bits is array (1 to 2) of array_1d_4_20bits;
	type array_2d_4x2_20bits is array (1 to 4) of array_1d_2_20bits;
	type array_2d_2x2_20bits is array (1 to 2) of array_1d_2_20bits;
	type array_2d_1x2_20bits is array (1 to 1) of array_1d_2_20bits;
	type array_2d_2x1_20bits is array (1 to 2) of array_1d_1_20bits;
	type array_2d_2x1_18bits is array (1 to 2) of array_1d_1_18bits;
	type array_2d_1x2_18bits is array (1 to 1) of array_1d_2_18bits;
	type array_2d_4x2_16bits is array (1 to 4) of array_1d_2_16bits;
	type array_2d_4x2_18bits is array (1 to 4) of array_1d_2_18bits;
	type array_2d_2x4_16bits is array (1 to 2) of array_1d_4_16bits;
	type array_2d_2x4_18bits is array (1 to 2) of array_1d_4_18bits;
	type array_2d_16x4_14bits is array (1 to 16) of array_1d_4_14bits;
	type array_2d_8x2_16bits is array (1 to 8) of array_1d_2_16bits;
	type array_2d_4x4_18bits is array (1 to 4) of array_1d_4_18bits;
	type array_2d_4x1_18bits is array (1 to 4) of array_1d_1_18bits;

	type array_1d_16_23bits is array (1 to 16) of std_logic_vector(22 downto 0);
	type array_1d_8_23bits is array (1 to 8) of std_logic_vector(22 downto 0);
	type array_1d_4_23bits is array (1 to 4) of std_logic_vector(22 downto 0);
	type array_1d_2_23bits is array (1 to 2) of std_logic_vector(22 downto 0);
	type array_1d_1_23bits is array (1 to 1) of std_logic_vector(22 downto 0);

	type array_2d_8x16_23bits is array (1 to 8) of array_1d_16_23bits;
	type array_2d_16x8_23bits is array (1 to 16) of array_1d_8_23bits;
	type array_2d_8x8_23bits is array (1 to 8) of array_1d_8_23bits;
	type array_2d_4x8_23bits is array (1 to 4) of array_1d_8_23bits;
	type array_2d_8x4_23bits is array (1 to 8) of array_1d_4_23bits;
	type array_2d_4x4_23bits is array (1 to 4) of array_1d_4_23bits;
	type array_2d_2x4_23bits is array (1 to 2) of array_1d_4_23bits;
	type array_2d_4x2_23bits is array (1 to 4) of array_1d_2_23bits;
	type array_2d_2x2_23bits is array (1 to 2) of array_1d_2_23bits;
	type array_2d_1x2_23bits is array (1 to 1) of array_1d_2_23bits;
	type array_2d_2x1_23bits is array (1 to 2) of array_1d_1_23bits;
	type array_2d_1x1_23bits is array (1 to 1) of array_1d_1_23bits;

	type array_2d_4x8_16bits is array (1 to 4) of array_1d_8_16bits;
	type array_2d_8x4_16bits is array (1 to 8) of array_1d_4_16bits;

--memória
	type array_1d_192_8bits is array (-64 to 127) of std_logic_vector(7 downto 0);	
	type array_2d_192x192_8bits is array (-64 to 127) of array_1d_192_8bits;	
  	type array_2d_64x64_8bits is array (1 to 64) of array_1d_64_8bits;

	type array_1d_200_8bits_Neg is array (-68 to 131) of std_logic_vector(7 downto 0);	
	type array_2d_200x200_8bits_Neg is array (-68 to 131) of array_1d_200_8bits_Neg;	
	
	type array_1d_192_8bits_Neg is array (-64 to 128) of std_logic_vector(7 downto 0);	
	type array_2d_192x192_8bits_Neg is array (-64 to 128) of array_1d_192_8bits_Neg;	
	
  	type array_1d_8_8bits is array(1 to 8) of std_logic_vector(7 downto 0);
  	type array_1d_4_9bits is array(1 to 4) of std_logic_vector(8 downto 0);
  	type array_1d_2_10bits is array(1 to 2) of std_logic_vector(9 downto 0);
	type array_1d_12_11bits is array (1 to 12) of std_logic_vector(10 downto 0);
	type array_1d_12_20bits is array (1 to 12) of std_logic_vector(19 downto 0);
	type array_1d_3_14bits is array (1 to 3) of std_logic_vector(13 downto 0);
	type array_1d_6_14bits is array (1 to 6) of std_logic_vector(13 downto 0);	
	type array_1d_7_14bits is array (1 to 7) of std_logic_vector(13 downto 0);	
	type array_1d_12_14bits is array (1 to 12) of std_logic_vector(13 downto 0);	
	type array_1d_13_14bits is array (1 to 13) of std_logic_vector(13 downto 0);	
	type array_1d_24_14bits is array (1 to 24) of std_logic_vector(13 downto 0);
	type array_1d_25_14bits is array (1 to 25) of std_logic_vector(13 downto 0);
	type array_1d_48_6bits is array (1 to 48) of std_logic_vector(5 downto 0);
	type array_1d_48_14bits is array (1 to 48) of std_logic_vector(13 downto 0);
	type array_1d_49_14bits is array (1 to 49) of std_logic_vector(13 downto 0);
	type array_1d_48_20bits is array (1 to 48) of std_logic_vector(19 downto 0);
	type array_1d_16_10bits is array (1 to 16) of std_logic_vector(9 downto 0);
	type array_1d_27_8bits is array (1 to 27) of std_logic_vector(7 downto 0);
	type array_1d_27_10bits is array (1 to 27) of std_logic_vector(9 downto 0);
	type array_1d_27_11bits is array (1 to 27) of std_logic_vector(10 downto 0);
	type array_2d_16x27_10bits is array (1 to 16, 1 to 27) of std_logic_vector(9 downto 0);
	type array_1d_9_11bits is array (1 to 9) of std_logic_vector(10 downto 0);
	type array_1d_9_10bits is array (1 to 9) of std_logic_vector(9 downto 0);



	type array_1d_72_10bits is array (1 to 72) of std_logic_vector(9 downto 0);
	type array_1d_193_10bits is array (1 to 193) of std_logic_vector(9 downto 0);
	type array_1d_193_11bits is array (1 to 193) of std_logic_vector(10 downto 0);
	type array_1d_195_10bits is array (1 to 195) of std_logic_vector(9 downto 0);
	type array_1d_195_11bits is array (1 to 195) of std_logic_vector(10 downto 0);
	
  	type array_1d_200_8bits is array(1 to 200) of std_logic_vector(7 downto 0);
  	type array_1d_200_10bits is array(1 to 200) of std_logic_vector(9 downto 0);
  	type array_1d_579_1bit is array(1 to 579) of std_logic;
  	type array_1d_579_8bits is array(1 to 579) of std_logic_vector(7 downto 0);
  	type array_1d_579_10bits is array(1 to 579) of std_logic_vector(9 downto 0);
  	type array_1d_579_11bits is array(1 to 579) of std_logic_vector(10 downto 0);








	type array_1d_64_1bit is array (1 to 64) of std_logic;
	type array_1d_6_13bits is array (1 to 6) of std_logic_vector(12 downto 0);	

--  
--  	--16x16
--  	type array_1d_16_21bits is array(1 to 16) of std_logic_vector(20 downto 0);
--  	type array_1d_16_4bits is array(1 to 16) of std_logic_vector(3 downto 0);
--  	type array_1d_8_21bits is array(1 to 8) of std_logic_vector(20 downto 0);
--  	type array_1d_8_4bits is array(1 to 8) of std_logic_vector(3 downto 0);
--  	type array_1d_4_21bits is array(1 to 4) of std_logic_vector(20 downto 0);
--  	type array_1d_4_4bits is array(1 to 4) of std_logic_vector(3 downto 0);
--  	type array_1d_2_21bits is array(1 to 2) of std_logic_vector(20 downto 0);
--  	type array_1d_2_11bits is array(1 to 2) of std_logic_vector(10 downto 0);
--  	type array_1d_2_4bits is array(1 to 2) of std_logic_vector(3 downto 0);
--  
--  	--8x8
--  	type array_1d_16_11bits is array(1 to 16) of std_logic_vector(10 downto 0);
--  	type array_1d_8_9bits is array(1 to 8) of std_logic_vector(8 downto 0);
--  
--	  
--  		type array_1d_48_1bit is array (1 to 48) of std_logic;
--  
--  		-- luan
--  
--  		type array_2d_12x8_8bits is array (1 to 12, 1 to 8) of std_logic_vector(7 downto 0);
--  		type array_1d_12_8bits is array (1 to 12) of std_logic_vector(7 downto 0);
--  		type array_1d_2_20bits is array (1 to 2) of std_logic_vector(19 downto 0);
--  		type array_1d_2_6bits is array (1 to 2) of std_logic_vector(5 downto 0);	
--  		type array_1d_3_20bits is array (1 to 3) of std_logic_vector(19 downto 0);
--  		type array_1d_3_6bits is array (1 to 3) of std_logic_vector(5 downto 0);		
--  		type array_1d_6_20bits is array (1 to 6) of std_logic_vector(19 downto 0);
--  		type array_1d_6_6bits is array (1 to 6) of std_logic_vector(5 downto 0);	
--  		type array_1d_12_6bits is array (1 to 12) of std_logic_vector(5 downto 0);	
--  		type array_1d_24_20bits is array (1 to 24) of std_logic_vector(19 downto 0);
--  		type array_1d_24_6bits is array (1 to 24) of std_logic_vector(5 downto 0);

--  
--  		type array_1d_16_16bits is array (1 to 16) of std_logic_vector(15 downto 0);
--  		--vladimir
--  		type array_1d_9_8bits is array (1 to 9) of std_logic_vector(7 downto 0);
--  		type array_2d_27x27_8bits is array (1 to 27, 1 to 27) of std_logic_vector(7 downto 0);
--  		type array_2d_27x8_8bits is array (1 to 27, 1 to 8) of std_logic_vector(7 downto 0);
--  		type array_2d_16x27_8bits is array (1 to 16, 1 to 27) of std_logic_vector(7 downto 0);
--  		type array_2d_8x27_8bits is array (1 to 8, 1 to 27) of std_logic_vector(7 downto 0);
--  		type array_2d_16x27_11bits is array (1 to 16, 1 to 27) of std_logic_vector(9 downto 0);
--  
--  		--vladimir
--  		type array_1d_24_16bits is array (1 to 24) of std_logic_vector(15 downto 0);
--  		type array_1d_9_16bits is array (1 to 9) of std_logic_vector(15 downto 0);
--  		type array_1d_27_16bits is array (1 to 27) of std_logic_vector(15 downto 0);
--  		-- para buffers
--  		--vladimir
--  		type array_2d_16x16_8bits is array (1 to 16, 1 to 16) of std_logic_vector(7 downto 0);
--  		--vladimir
--  		type array_2d_14x14_8bits is array (1 to 14, 1 to 14) of std_logic_vector(7 downto 0);
--  		type array_2d_9x14_8bits is array (1 to 9, 1 to 14) of std_logic_vector(7 downto 0);
--  		type array_2d_10x9_8bits is array (1 to 10, 1 to 9) of std_logic_vector(7 downto 0);
--  		type array_2d_9x9_8bits is array (1 to 9, 1 to 9) of std_logic_vector(7 downto 0);
--  		type array_2d_9x10_16bits is array (1 to 9, 1 to 10) of std_logic_vector(15 downto 0);
--  		type array_2d_8x8_8bits is array (1 to 8, 1 to 8) of std_logic_vector(7 downto 0);
--  		type array_1d_10_16bits is array (1 to 10) of std_logic_vector(15 downto 0);
--  		type array_1d_14_8bits is array (1 to 14) of std_logic_vector(7 downto 0);
--  
--  		type array_2d_12x8_8b is array(1 to 12, 1 to 8) of std_logic_vector(7 downto 0);
--  
--  		type array_2d_27x2_8bits is array(1 to 27, 1 to 2) of std_logic_vector(7 downto 0);
--		  
--  		--type array_1d_24_8bits is array(1 to 24) of std_logic_vector(7 downto 0);
--  		--type array_1d_51_8bits is array(1 to 51) of std_logic_vector(7 downto 0);
--		  
--	  
--  	--FME 16x16
--  		--Interpolador
--  			type array_1d_24_8bits is array (1 to 24) of std_logic_vector(7 downto 0);--linha de entrada da memória
--  			type array_1d_24_10bits is array (1 to 24) of std_logic_vector(9 downto 0);
--  			type array_2d_24x51_10bits is array (1 to 24, 1 to 51) of std_logic_vector(9 downto 0);--buffer type-h
--  			type array_1d_51_10bits is array (1 to 51) of std_logic_vector(9 downto 0);--conexão Filtro -> bufferTypeH
--  			type array_1d_51_11bits is array (1 to 51) of std_logic_vector(10 downto 0);--saida Filtros
--  			type array_1d_51_8bits is array (1 to 51) of std_logic_vector(7 downto 0);--entrada Clip
--  
--  
--  			type array_1d_17_11bits is array (1 to 17) of std_logic_vector(10 downto 0);--saidaFiltro
--  			type array_1d_17_10bits is array (1 to 17) of std_logic_vector(9 downto 0);--saidaFiltro
--  
--  
--  		--Comparador:
--  			type array_1d_4_10bits is array (1 to 4) of std_logic_vector(9 downto 0);
--  			type array_1d_12_12bits is array (1 to 12) of std_logic_vector(11 downto 0);
--  			type array_1d_12_21bits is array (1 to 12) of std_logic_vector(20 downto 0);
--  			type array_1d_48_21bits is array (1 to 48) of std_logic_vector(20 downto 0);
--  			type array_1d_24_21bits is array (1 to 24) of std_logic_vector(20 downto 0);	
--  			type array_1d_6_21bits is array (1 to 6) of std_logic_vector(20 downto 0);
--  			type array_1d_3_21bits is array (1 to 3) of std_logic_vector(20 downto 0);
--  
--	  
--  	--32x32
--  		--Interpolador
--  			type array_1d_40_8bits is array (1 to 40) of std_logic_vector(7 downto 0);--linha de entrada da memória
--  			type array_1d_40_10bits is array (1 to 40) of std_logic_vector(9 downto 0);
--  			type array_2d_40x99_10bits is array (1 to 40, 1 to 99) of std_logic_vector(9 downto 0);--buffer type-h
--  			type array_1d_99_10bits is array (1 to 99) of std_logic_vector(9 downto 0);--conexão Filtro -> bufferTypeH
--  			type array_1d_99_11bits is array (1 to 99) of std_logic_vector(10 downto 0);--saida Filtros
--  			type array_1d_99_8bits is array (1 to 99) of std_logic_vector(7 downto 0);--entrada Clip
--  
--  			type array_1d_33_11bits is array (1 to 33) of std_logic_vector(10 downto 0);--saidaFiltro
--  			type array_1d_33_10bits is array (1 to 33) of std_logic_vector(9 downto 0);--saidaFiltro
--  
--  		--Comparador 32x32:
  			type array_1d_32_8bits is array (1 to 32) of std_logic_vector(7 downto 0);
  			type array_1d_32_9bits is array (1 to 32) of std_logic_vector(8 downto 0);
--  			type array_1d_16_9bits is array (1 to 16) of std_logic_vector(8 downto 0);
  			type array_1d_8_10bits is array (1 to 8) of std_logic_vector(9 downto 0);
  			type array_1d_4_11bits is array (1 to 4) of std_logic_vector(10 downto 0);
  			type array_1d_2_12bits is array (1 to 2) of std_logic_vector(11 downto 0);
--  
--  			type array_1d_12_13bits is array (1 to 12) of std_logic_vector(12 downto 0);
--  
--  			type array_1d_48_22bits is array (1 to 48) of std_logic_vector(21 downto 0);
--  			type array_1d_24_22bits is array (1 to 24) of std_logic_vector(21 downto 0);	
--  			type array_1d_12_22bits is array (1 to 12) of std_logic_vector(21 downto 0);
--  			type array_1d_6_22bits is array (1 to 6) of std_logic_vector(21 downto 0);
--  			type array_1d_3_22bits is array (1 to 3) of std_logic_vector(21 downto 0);
--  			type array_1d_2_22bits is array (1 to 2) of std_logic_vector(21 downto 0);
--	  
--  	--TZS
--  		--64x64
--  			type array_1d_195_11bits is array (1 to 195) of std_logic_vector(10 downto 0);
--  			type array_1d_195_10bits is array (1 to 195) of std_logic_vector(9 downto 0);
  			type array_1d_195_8bits is array (1 to 195) of std_logic_vector(7 downto 0);
--  			type array_1d_72_10bits is array (1 to 72) of std_logic_vector(9 downto 0);
--  			type array_1d_72_8bits is array (1 to 72) of std_logic_vector(7 downto 0);
  			type array_1d_65_11bits is array (1 to 65) of std_logic_vector(10 downto 0);
  			type array_1d_65_10bits is array (1 to 65) of std_logic_vector(9 downto 0);
  			type array_1d_48_23bits is array (1 to 48) of std_logic_vector(22 downto 0);
  			type array_1d_49_23bits is array (1 to 49) of std_logic_vector(22 downto 0);
--  			type array_1d_24_23bits is array (1 to 24) of std_logic_vector(22 downto 0);
  			type array_1d_25_23bits is array (1 to 25) of std_logic_vector(22 downto 0);
--  			type array_1d_12_23bits is array (1 to 12) of std_logic_vector(22 downto 0);
  			type array_1d_13_23bits is array (1 to 13) of std_logic_vector(22 downto 0);
--  			type array_1d_12_14bits is array (1 to 12) of std_logic_vector(13 downto 0);
  			type array_1d_6_23bits is array (1 to 6) of std_logic_vector(22 downto 0);
  			type array_1d_7_23bits is array (1 to 7) of std_logic_vector(22 downto 0);
--  			type array_1d_3_23bits is array (1 to 3) of std_logic_vector(22 downto 0);
  			
--  
--  		--fme
--  			type array_1d_64_8bits is array (1 to 64) of std_logic_vector(7 downto 0);
--			  
--  
--  		--tzs
  			type array_1d_64_9bits is array (1 to 64) of std_logic_vector(8 downto 0);
--  			type array_1d_16_14bits is array (1 to 16) of std_logic_vector(13 downto 0);
  			type array_1d_8_11bits is array (1 to 8) of std_logic_vector(10 downto 0);
  			type array_1d_4_12bits is array (1 to 4) of std_logic_vector(11 downto 0);
  			type array_1d_2_13bits is array (1 to 2) of std_logic_vector(12 downto 0);
--  
--  
--  		--32x32
--  			type array_1d_32_21bits is array(1 to 32) of std_logic_vector(20 downto 0);
--  			type array_1d_32_12bits is array(1 to 32) of std_logic_vector(11 downto 0);
--  			type array_1d_32_5bits is array(1 to 32) of std_logic_vector(4 downto 0);
--  			type array_1d_32_4bits is array(1 to 32) of std_logic_vector(3 downto 0);
--  			type array_1d_16_13bits is array(1 to 16) of std_logic_vector(12 downto 0);
--  			type array_1d_16_22bits is array(1 to 16) of std_logic_vector(21 downto 0);
--  			type array_1d_8_22bits is array(1 to 8) of std_logic_vector(21 downto 0);
--  			type array_1d_4_22bits is array(1 to 4) of std_logic_vector(21 downto 0);
  			--type array_1d_4_23bits is array(1 to 4) of std_logic_vector(22 downto 0);
--		  
--  
--  		--16x16	
--  			type array_1d_16_12bits is array(1 to 16) of std_logic_vector(11 downto 0);					
--  
--	  
--  


--  
  	type array_2d_8x8_8bits_2 is array (1 to 8) of array_1d_8_8bits;
  	type array_2d_16x16_8bits_2 is array (1 to 16) of array_1d_16_8bits;
--  	type array_2d_16x8_8bits is array(1 to 16) of array_1d_8_8bits;
--  	type array_2d_16x32_8bits is array(1 to 16) of array_1d_32_8bits;
--  	type array_2d_16x64_8bits is array(1 to 16) of array_1d_64_8bits;
--  	type array_2d_24x24_8bits is array (1 to 24) of array_1d_24_8bits;
--  	type array_2d_32x32_8bits is array (1 to 32) of array_1d_32_8bits;
--  	type array_2d_40x40_8bits is array (1 to 40) of array_1d_40_8bits;
--  	type array_2d_64x64_8bits is array (1 to 64) of array_1d_64_8bits;

  	type array_2d_72x72_8bits is array(1 to 72) of array_1d_72_8bits;
--  
  	type array_2d_72x195_10bits is array(1 to 72) of array_1d_195_10bits;

--	  
  	
  	type array_2d_192x579_8bits is array(1 to 192) of array_1d_579_8bits;
  	type array_2d_200x200_8bits is array(1 to 200) of array_1d_200_8bits;
  	type array_2d_200x579_8bits is array(1 to 200) of array_1d_579_8bits;
  	type array_2d_200x579_10bits is array(1 to 200) of array_1d_579_10bits;
  	type array_2d_579x200_8bits is array(1 to 579) of array_1d_200_8bits;
  	type array_2d_579x200_10bits is array(1 to 579) of array_1d_200_10bits;
  	type array_2d_195x72_10bits is array(1 to 195) of array_1d_72_10bits;

  	type array_2d_200x579_1bit is array (1 to 200) of array_1d_579_1bit;
	type array_2d_192x579_1bit is array (1 to 192) of array_1d_579_1bit;
  	

--  	type array_3d_16x32x32_8bits is array (1 to 16) of array_2d_32x32_8bits;
--	  

type array_1d_256_8bits is array(1 to 256) of std_logic_vector(7 downto 0);
type array_1d_1080_8bits is array(1 to 1080) of std_logic_vector(7 downto 0);
	
end ME_types;
