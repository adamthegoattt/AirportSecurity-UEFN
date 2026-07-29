"""Start the local-only UEFN editor bridge for AirportSecurity.

UEFN executes this file when the project opens and Python editor scripting is
enabled.  The listener binds to 127.0.0.1 only and dispatches all Unreal API
work onto the editor tick thread.
"""

import unreal


def _start_airport_security_bridge():
    try:
        import uefn_listener

        if uefn_listener._server is None:
            port = uefn_listener.start_listener(show_status=False)
            unreal.log(f"[TL] AirportSecurity editor bridge started on 127.0.0.1:{port}")
        else:
            unreal.log(
                "[TL] AirportSecurity editor bridge already running on "
                f"127.0.0.1:{uefn_listener._bound_port}"
            )
    except Exception as error:
        unreal.log_error(f"[TL] AirportSecurity editor bridge failed: {error}")


_start_airport_security_bridge()
