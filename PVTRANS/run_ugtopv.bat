@rem  run_ugtopv
@rem  Copyright 2014 Siemens Product Lifecycle Management Software Inc.
@rem  This script selects an appropriate version of UG translator

@if not exist "%UGII_BASE_DIR%" goto :no_ug
@setlocal

@set PATH=%UGII_BASE_DIR%\NXBIN;%PATH%
@set JTK_USE_MASTER_NOTATION_PMI_FORMAT=1
@set UGII_PV_TRANS_MODEL_ANN=1

@rem This must be set to use the instance ID for CADIDs
@set JTK_XLATR_ENABLE_PERSISTED_INSTANCE_ID=1

@"%UGII_BASE_DIR%\nxbin\ugtopv.exe" %*

@endlocal
@goto :end

:no_ug
@echo "The environment variable UGII_BASE_DIR is not set"
@echo "Exiting..."
@goto :end

:end
