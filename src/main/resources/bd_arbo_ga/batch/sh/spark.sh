#!/bin/bash

bdl_utlspark_submit "spk.common" "spk.spark"

_cr=${?}

if [  ${_cr} -ne 0 ]; then return 3; fi

return 0
