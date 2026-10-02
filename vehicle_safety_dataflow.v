`timescale 1ns / 1ps
`default_nettype none

module vehicle_safety_dataflow (
    input  wire [15:0] sw,
    output wire [15:0] led
);
    wire seat_warn, door_warn, hood_warn, trunk_warn;
    wire bat_warn, airbag_warn, temp_warn;
    wire warn_pri1, warn_pri2, belt_ok, base_ok;
    wire start_permit, chime;

    assign seat_warn   = ~sw[15] | (sw[6] & ~sw[5]);
    assign door_warn   = ~sw[14];
    assign hood_warn   = ~sw[10];
    assign trunk_warn  = ~sw[4];
    assign bat_warn    = ~sw[9];
    assign airbag_warn = ~sw[8];
    assign temp_warn   = ~sw[7];

    assign warn_pri1 = hood_warn | bat_warn | airbag_warn | temp_warn;
    assign warn_pri2 = seat_warn | door_warn | trunk_warn;
    assign belt_ok = sw[15] & (~sw[6] | sw[5]);
    assign base_ok = sw[13] & sw[12] & sw[11] & sw[3] & sw[14]
                   & sw[10] & sw[4] & sw[9] & sw[8] & sw[7];
    assign start_permit = base_ok & (sw[2] | belt_ok);
    assign chime = sw[13] & (warn_pri1 | warn_pri2 | ~sw[3]);

    assign led = {start_permit, chime, warn_pri2, warn_pri1,
                  seat_warn, door_warn, hood_warn, trunk_warn,
                  bat_warn, airbag_warn, temp_warn, 5'b00000};
endmodule

`default_nettype wire
