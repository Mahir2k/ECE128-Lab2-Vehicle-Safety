`timescale 1ns / 1ps
`default_nettype none

module vehicle_safety_behavioral (
    input  wire [15:0] sw,
    output reg  [15:0] led
);
    reg seat_warn, door_warn, hood_warn, trunk_warn;
    reg bat_warn, airbag_warn, temp_warn;
    reg warn_pri1, warn_pri2, belt_ok, base_ok;
    reg start_permit, chime;

    always @* begin
        seat_warn   = !sw[15] || (sw[6] && !sw[5]);
        door_warn   = !sw[14];
        hood_warn   = !sw[10];
        trunk_warn  = !sw[4];
        bat_warn    = !sw[9];
        airbag_warn = !sw[8];
        temp_warn   = !sw[7];

        warn_pri1 = hood_warn || bat_warn || airbag_warn || temp_warn;
        warn_pri2 = seat_warn || door_warn || trunk_warn;
        belt_ok = sw[15] && (!sw[6] || sw[5]);
        base_ok = sw[13] && sw[12] && sw[11] && sw[3] && sw[14]
               && sw[10] && sw[4] && sw[9] && sw[8] && sw[7];
        start_permit = base_ok && (sw[2] || belt_ok);
        chime = sw[13] && (warn_pri1 || warn_pri2 || !sw[3]);

        led = {start_permit, chime, warn_pri2, warn_pri1,
               seat_warn, door_warn, hood_warn, trunk_warn,
               bat_warn, airbag_warn, temp_warn, 5'b00000};
    end
endmodule

`default_nettype wire
