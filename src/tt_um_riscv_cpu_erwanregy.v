module alu (
	operation,
	operand_1,
	operand_2,
	result
);
	reg _sv2v_0;
	input wire [31:0] operation;
	input signed [31:0] operand_1;
	input signed [31:0] operand_2;
	output reg signed [31:0] result;
	wire [4:0] shift_amount = operand_2[4:0];
	always @(*) begin
		if (_sv2v_0)
			;
		(* full_case, parallel_case *)
		casez (operation)
			32'd0: result = operand_1 + operand_2;
			32'd1: result = operand_1 - operand_2;
			32'd2: result = operand_1 << shift_amount;
			32'd3: result = operand_1 < operand_2;
			32'd4: result = $unsigned(operand_1) < $unsigned(operand_2);
			32'd5: result = operand_1 ^ operand_2;
			32'd6: result = operand_1 >> shift_amount;
			32'd7: result = operand_1 >>> shift_amount;
			32'd8: result = operand_1 & operand_2;
			32'd9: result = operand_1 & operand_2;
			default: result = 0;
		endcase
	end
	initial _sv2v_0 = 0;
endmodule
module branch_logic (
	clock,
	reset,
	branch,
	immediate,
	program_counter,
	program_counter_plus_4
);
	parameter signed [31:0] ADDRESS_WIDTH = 32;
	input clock;
	input reset;
	input branch;
	input [31:0] immediate;
	output reg [ADDRESS_WIDTH - 1:0] program_counter;
	output wire [ADDRESS_WIDTH - 1:0] program_counter_plus_4;
	function automatic [ADDRESS_WIDTH - 1:0] sv2v_cast_3D987;
		input reg [ADDRESS_WIDTH - 1:0] inp;
		sv2v_cast_3D987 = inp;
	endfunction
	wire signed [ADDRESS_WIDTH - 1:0] relative_address = sv2v_cast_3D987(immediate << 1);
	assign program_counter_plus_4 = program_counter + 4;
	always @(posedge clock or posedge reset)
		if (reset)
			program_counter <= 0;
		else if (branch)
			program_counter <= program_counter + relative_address;
		else
			program_counter <= program_counter_plus_4;
endmodule
module cpu (
	clock,
	reset,
	address,
	write_enable,
	write_data,
	read_data
);
	reg _sv2v_0;
	parameter signed [31:0] BUS_ADDRESS_WIDTH = 32;
	parameter signed [31:0] BUS_DATA_WIDTH = 32;
	input clock;
	input reset;
	output wire [BUS_ADDRESS_WIDTH - 1:0] address;
	output wire write_enable;
	output wire [BUS_DATA_WIDTH - 1:0] write_data;
	input [BUS_DATA_WIDTH - 1:0] read_data;
	localparam signed [31:0] NumInstructions = 15;
	localparam signed [31:0] InstructionAddressWidth = 4;
	wire [38:0] control;
	wire signed [31:0] immediate;
	wire [14:0] program_counter;
	wire [14:0] program_counter_plus_4;
	branch_logic #(.ADDRESS_WIDTH(InstructionAddressWidth)) branch_logic(
		.clock(clock),
		.reset(reset),
		.branch(control[38]),
		.immediate(immediate),
		.program_counter(program_counter),
		.program_counter_plus_4(program_counter_plus_4)
	);
	wire [3:0] instruction;
	rom #(.NUM_WORDS(NumInstructions)) instruction_memory(
		.address(program_counter),
		.data(instruction)
	);
	wire [31:0] memory_read_data;
	wire signed [31:0] alu_result;
	wire signed [31:0] register_read_data_1;
	wire signed [31:0] register_read_data_2;
	reg signed [31:0] register_write_data;
	localparam [0:0] Immediate = 1;
	always @(*) begin
		if (_sv2v_0)
			;
		(* full_case, parallel_case *)
		casez (control[1-:2])
			2'd0: register_write_data = alu_result;
			2'd2: register_write_data = memory_read_data;
			Immediate: register_write_data = immediate;
			2'd3: register_write_data = program_counter_plus_4;
			default: register_write_data = 0;
		endcase
	end
	register_file register_file(
		.clock(clock),
		.reset(reset),
		.write_enable(control[2]),
		.write_address(instruction[11:7]),
		.write_data(register_write_data),
		.read_address_1(instruction[19:15]),
		.read_address_2(instruction[24:20]),
		.read_data_1(register_read_data_1),
		.read_data_2(register_read_data_2)
	);
	instruction_decoder instruction_decoder(
		.instruction(instruction),
		.alu_result(alu_result[0]),
		.control(control)
	);
	immediate_generator immediate_generator(
		.instruction(instruction),
		.immediate(immediate)
	);
	alu alu(
		.operation(control[35-:32]),
		.operand_1((control[37] ? program_counter : register_read_data_1)),
		.operand_2((control[36] ? immediate : register_read_data_2)),
		.result(alu_result)
	);
	function automatic signed [BUS_ADDRESS_WIDTH - 1:0] sv2v_cast_C6B10_signed;
		input reg signed [BUS_ADDRESS_WIDTH - 1:0] inp;
		sv2v_cast_C6B10_signed = inp;
	endfunction
	assign address = sv2v_cast_C6B10_signed(alu_result);
	assign write_enable = control[3];
	function automatic signed [BUS_DATA_WIDTH - 1:0] sv2v_cast_3C259_signed;
		input reg signed [BUS_DATA_WIDTH - 1:0] inp;
		sv2v_cast_3C259_signed = inp;
	endfunction
	assign write_data = sv2v_cast_3C259_signed(register_read_data_2);
	function automatic [31:0] sv2v_cast_32;
		input reg [31:0] inp;
		sv2v_cast_32 = inp;
	endfunction
	assign memory_read_data = sv2v_cast_32(read_data);
	initial _sv2v_0 = 0;
endmodule
module immediate_generator (
	instruction,
	immediate
);
	reg _sv2v_0;
	input [31:0] instruction;
	output reg signed [31:0] immediate;
	wire [6:0] opcode;
	assign opcode = instruction[6:0];
	reg [31:0] instruction_format;
	always @(*) begin
		if (_sv2v_0)
			;
		(* full_case, parallel_case *)
		casez (opcode)
			7'b0000011, 7'b0010011, 7'b1100111: instruction_format = 32'd1;
			7'b0100011: instruction_format = 32'd2;
			7'b1100011: instruction_format = 32'd3;
			7'b0010111, 7'b0110111: instruction_format = 32'd4;
			7'b1101111: instruction_format = 32'd5;
			default: instruction_format = 32'd0;
		endcase
	end
	always @(*) begin
		if (_sv2v_0)
			;
		(* full_case, parallel_case *)
		casez (instruction_format)
			32'd1: immediate = $signed(instruction[31:20]);
			32'd2: immediate = $signed({instruction[31:25], instruction[11:7]});
			32'd3: immediate = $signed({instruction[31], instruction[7], instruction[30:25], instruction[11:8]});
			32'd4: immediate = {instruction[31:12], 12'b000000000000};
			32'd5: immediate = $signed({instruction[31], instruction[19:12], instruction[20], instruction[30:21], 1'b0});
			default: immediate = 0;
		endcase
	end
	initial _sv2v_0 = 0;
endmodule
module instruction_decoder (
	instruction,
	alu_result,
	control
);
	reg _sv2v_0;
	input [31:0] instruction;
	input alu_result;
	output reg [38:0] control;
	localparam [0:0] False = 0;
	localparam [0:0] True = 1;
	wire [6:0] opcode;
	assign opcode = instruction[6:0];
	wire [2:0] funct3 = instruction[14:12];
	wire [6:0] funct7 = instruction[31:25];
	reg [31:0] operation;
	localparam [0:0] Immediate = 1;
	always @(*) begin
		if (_sv2v_0)
			;
		control = 0;
		operation = 32'd0;
		(* full_case, parallel_case *)
		casez (opcode)
			7'b0110111: begin
				control[2] = True;
				control[1-:2] = Immediate;
				operation = 32'bzzzzzzzzzzzzzzzzzzzzzzzzz0110111;
			end
			7'b0010111: begin
				control[2] = True;
				control[37] = 1'b1;
				control[36] = Immediate;
				control[35-:32] = 32'd0;
				control[2] = True;
				control[1-:2] = 2'd0;
				operation = 32'bzzzzzzzzzzzzzzzzzzzzzzzzz0010111;
			end
			7'b1101111: begin
				control[37] = 1'b1;
				control[36] = Immediate;
				control[35-:32] = 32'd0;
				control[2] = True;
				control[1-:2] = 2'd3;
				operation = 32'bzzzzzzzzzzzzzzzzzzzzzzzzz1101111;
			end
			7'b1100111: begin
				control[36] = Immediate;
				control[35-:32] = 32'd0;
				control[2] = True;
				control[1-:2] = 2'd3;
				operation = 32'bzzzzzzzzzzzzzzzzz000zzzzz1100111;
			end
			7'b1100011:
				(* full_case, parallel_case *)
				casez (funct3)
					3'b000: begin
						control[35-:32] = 32'd1;
						control[38] = alu_result == 0;
						operation = 32'bzzzzzzzzzzzzzzzzz000zzzzz1100011;
					end
					3'b001: begin
						control[35-:32] = 32'd1;
						control[38] = alu_result != 0;
						operation = 32'bzzzzzzzzzzzzzzzzz001zzzzz1100011;
					end
					3'b100: begin
						control[35-:32] = 32'd3;
						control[38] = alu_result == True;
						operation = 32'bzzzzzzzzzzzzzzzzz100zzzzz1100011;
					end
					3'b101: begin
						control[35-:32] = 32'd3;
						control[38] = alu_result == False;
						operation = 32'bzzzzzzzzzzzzzzzzz101zzzzz1100011;
					end
					3'b110: begin
						control[35-:32] = 32'd4;
						control[38] = alu_result == True;
						operation = 32'bzzzzzzzzzzzzzzzzz110zzzzz1100011;
					end
					3'b111: begin
						control[35-:32] = 32'd4;
						control[38] = alu_result == False;
						operation = 32'bzzzzzzzzzzzzzzzzz111zzzzz1100011;
					end
					default: begin
						control[35-:32] = 32'd10;
						control[38] = False;
						operation = 32'd0;
					end
				endcase
			7'b0z00011: begin
				control[36] = Immediate;
				control[35-:32] = 32'd0;
				if (opcode == 7'b0000011) begin
					control[2] = True;
					control[1-:2] = 2'd2;
				end
				if (opcode == 7'b0100011)
					control[3] = True;
				(* full_case, parallel_case *)
				casez (funct3)
					3'b000: operation = (opcode == 7'b0000011 ? 32'bzzzzzzzzzzzzzzzzz000zzzzz0000011 : 32'bzzzzzzzzzzzzzzzzz000zzzzz0100011);
					3'b001: operation = (opcode == 7'b0000011 ? 32'bzzzzzzzzzzzzzzzzz001zzzzz0000011 : 32'bzzzzzzzzzzzzzzzzz001zzzzz0100011);
					3'b010: operation = (opcode == 7'b0000011 ? 32'bzzzzzzzzzzzzzzzzz010zzzzz0000011 : 32'bzzzzzzzzzzzzzzzzz010zzzzz0100011);
					3'b100: operation = (opcode == 7'b0000011 ? 32'bzzzzzzzzzzzzzzzzz100zzzzz0000011 : 32'd0);
					3'b101: operation = (opcode == 7'b0000011 ? 32'bzzzzzzzzzzzzzzzzz101zzzzz0000011 : 32'd0);
					default: operation = 32'd0;
				endcase
			end
			7'b0z10011: begin
				control[2] = True;
				if (opcode == 7'b0010011)
					control[36] = Immediate;
				(* full_case, parallel_case *)
				casez (funct3)
					3'b000:
						if (opcode == 7'b0010011) begin
							control[35-:32] = 32'd0;
							operation = 32'bzzzzzzzzzzzzzzzzz000zzzzz0010011;
						end
						else if (funct7[5] == 0) begin
							control[35-:32] = 32'd0;
							operation = 32'b0000000zzzzzzzzzz000zzzzz0110011;
						end
						else begin
							control[35-:32] = 32'd1;
							operation = 32'b0100000zzzzzzzzzz000zzzzz0110011;
						end
					3'b001: begin
						control[35-:32] = 32'd2;
						operation = (opcode == 7'b0010011 ? 32'b0000000zzzzzzzzzz001zzzzz0010011 : 32'b0000000zzzzzzzzzz001zzzzz0110011);
					end
					3'b011: begin
						control[35-:32] = 32'd4;
						operation = (opcode == 7'b0010011 ? 32'bzzzzzzzzzzzzzzzzz010zzzzz0010011 : 32'b0000000zzzzzzzzzz010zzzzz0110011);
					end
					3'b100: begin
						control[35-:32] = 32'd5;
						operation = (opcode == 7'b0010011 ? 32'bzzzzzzzzzzzzzzzzz100zzzzz0010011 : 32'b0000000zzzzzzzzzz100zzzzz0110011);
					end
					3'b101:
						if (funct7[5] == 0) begin
							control[35-:32] = 32'd6;
							operation = (opcode == 7'b0010011 ? 32'b0000000zzzzzzzzzz101zzzzz0010011 : 32'b0000000zzzzzzzzzz101zzzzz0110011);
						end
						else begin
							control[35-:32] = 32'd7;
							operation = (opcode == 7'b0010011 ? 32'b0100000zzzzzzzzzz101zzzzz0010011 : 32'b0100000zzzzzzzzzz101zzzzz0110011);
						end
					3'b110: begin
						control[35-:32] = 32'd8;
						operation = (opcode == 7'b0010011 ? 32'bzzzzzzzzzzzzzzzzz110zzzzz0010011 : 32'b0000000zzzzzzzzzz110zzzzz0110011);
					end
					3'b111: begin
						control[35-:32] = 32'd9;
						operation = (opcode == 7'b0010011 ? 32'bzzzzzzzzzzzzzzzzz111zzzzz0010011 : 32'b0000000zzzzzzzzzz111zzzzz0110011);
					end
					default: begin
						control[35-:32] = 32'd10;
						operation = 32'd0;
					end
				endcase
			end
			7'b0001111:
				;
			7'b1110011:
				;
			default: begin
				control = 0;
				operation = 32'd0;
			end
		endcase
	end
	initial _sv2v_0 = 0;
endmodule
module ram (
	clock,
	address,
	write_enable,
	write_data,
	read_data
);
	parameter signed [31:0] NUM_BYTES = 16;
	input clock;
	input [$clog2(NUM_BYTES) - 1:0] address;
	input write_enable;
	input [31:0] write_data;
	output wire [31:0] read_data;
	reg [31:0] memory [0:(NUM_BYTES / 4) - 1];
	always @(posedge clock)
		if (write_enable)
			memory[address / 4] <= write_data;
	assign read_data = memory[address / 4];
endmodule
module register_file (
	clock,
	reset,
	write_enable,
	write_address,
	write_data,
	read_address_1,
	read_address_2,
	read_data_1,
	read_data_2
);
	input clock;
	input reset;
	input write_enable;
	input [4:0] write_address;
	input [31:0] write_data;
	input [4:0] read_address_1;
	input [4:0] read_address_2;
	output wire [31:0] read_data_1;
	output wire [31:0] read_data_2;
	reg [31:0] registers [0:31];
	always @(posedge clock or posedge reset)
		if (reset) begin
			registers[0] <= 0;
			registers[2] <= 0;
		end
		else if ((write_address != 0) && write_enable)
			registers[write_address] <= write_data;
	assign read_data_1 = registers[read_address_1];
	assign read_data_2 = registers[read_address_2];
endmodule
module rom (
	address,
	data
);
	parameter signed [31:0] NUM_WORDS = 16;
	input [$clog2(NUM_WORDS) - 1:0] address;
	output wire [31:0] data;
	wire [31:0] memory [0:NUM_WORDS - 1];
	assign memory[0] = 'hfe010113;
	assign memory[1] = 'h812e23;
	assign memory[2] = 'h2010413;
	assign memory[3] = 'h300793;
	assign memory[4] = 'hfef42623;
	assign memory[5] = 'h400793;
	assign memory[6] = 'hfef42423;
	assign memory[7] = 'hfec42703;
	assign memory[8] = 'hfe842783;
	assign memory[9] = 'hf707b3;
	assign memory[10] = 'hfef42223;
	assign memory[11] = 'h13;
	assign memory[12] = 'h1c12403;
	assign memory[13] = 'h2010113;
	assign memory[14] = 'h8067;
	assign data = memory[address];
endmodule
`default_nettype none
module tt_um_riscv_cpu_erwanregy (
	ui_in,
	uo_out,
	uio_in,
	uio_out,
	uio_oe,
	ena,
	clk,
	rst_n
);
	input wire [7:0] ui_in;
	output wire [7:0] uo_out;
	input wire [7:0] uio_in;
	output wire [7:0] uio_out;
	output wire [7:0] uio_oe;
	input wire ena;
	input wire clk;
	input wire rst_n;
	wire write_enable;
	cpu #(
		.BUS_ADDRESS_WIDTH(8),
		.BUS_DATA_WIDTH(8)
	) cpu(
		.clock(clk),
		.reset(~rst_n),
		.address(uo_out),
		.write_enable(write_enable),
		.write_data(uio_out),
		.read_data(uio_in)
	);
	assign uio_oe = {8 {write_enable}};
endmodule
