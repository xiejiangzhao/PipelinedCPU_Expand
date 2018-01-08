
module lpm_dataRam (
	clock,
	data,
	rdaddress,
	wraddress,
	wren,
	q);

	input	  clock;
	input	[31:0]  data;
	input	[4:0]  rdaddress;
	input	[4:0]  wraddress;
	input	  wren;
	output	[31:0]  q;
`ifndef ALTERA_RESERVED_QIS
// synopsys translate_off
`endif
	tri1	  wren;
`ifndef ALTERA_RESERVED_QIS
// synopsys translate_on
`endif

endmodule

