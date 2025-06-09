#!/bin/bash
# Follow GoFetchRover Muled system service logs in real-time
/bin/echo ""
/bin/echo "Watching gofetchrover-muled.service logs in realtime..."
/bin/echo "		(To stop watching and exit, press Ctrl-C)"
/bin/echo ""
/usr/bin/journalctl --follow -u gofetchrover-muled.service
