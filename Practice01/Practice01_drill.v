module carWarning(Alarm, DoorClose, Ignition, SeatBelt);

	output		Alarm;
	
	input		DoorClose		;
	input		Ignition;
	input		SeatBelt;
	
	wire	DoorOpened;
	wire	NoSeatBelt;
	
	wire	Node1;
	wire	Node2;

	not	NOT_U0(DoorOpened, DoorClose);
	not	NOT_U1(NoSeatBelt, SeatBelt);
	
	and	AND_U0(Node1, DoorOpened, Ignition);
	and	AND_U1(Node2, NoSeatBelt, Ignition);

	or	OR_U0(Alarm, Node1, Node2);

endmodule

module	tb;
	reg	DoorClose;
	reg	Ignition;
	reg	SeatBelt;

	wire	Alarm;

	carWarning	DUT(	.Alarm		(Alarm		),
				.DoorClose	(DoorClose	),
				.Ignition	(Ignition	),
				.SeatBelt	(SeatBelt	));

	initial begin
		DoorClose	=1'b1;
		Ignition	=1'b0;
		SeatBelt	=1'b0;
	end

	always begin
	#100
		DoorClose	=1'b0;
		Ignition	=1'b0;
		SeatBelt	=1'b0;
	#100
		DoorClose	=1'b0;
		Ignition	=1'b1;
		SeatBelt	=1'b0;	
	#100
		DoorClose	=1'b1;
		Ignition	=1'b1;
		SeatBelt	=1'b0;	
	#100
		DoorClose	=1'b1;
		Ignition	=1'b1;
		SeatBelt	=1'b1;
	#100
		$finish	;

	end

endmodule
