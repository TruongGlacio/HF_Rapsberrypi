
#-------------------------------------------------
#
# Project created by QtCreator 2017-04-05T15:28:23
#
#-------------------------------------------------

QT       += core gui network widgets
QT += multimedia
QT += widgets


greaterThan(QT_MAJOR_VERSION, 5): QT += widgets

TARGET = HF_Gui

TEMPLATE = app


SOURCES += main.cpp\
        mainwindow.cpp \
    receiver.cpp \
    dsp/agc_impl.cpp \
    dsp/correct_iq_cc.cpp \
    dsp/hbf_decim.cpp \
    dsp/lpf.cpp \
    dsp/resampler_xx.cpp \
    dsp/rx_agc_xx.cpp \
    dsp/rx_demod_am.cpp \
    dsp/rx_demod_fm.cpp \
    dsp/rx_fft.cpp \
    dsp/rx_filter.cpp \
    dsp/rx_meter.cpp \
    dsp/rx_noise_blanker_cc.cpp \
    dsp/rx_rds.cpp \
    dsp/sniffer_f.cpp \
    dsp/stereo_demod.cpp \
    dsp/afsk1200/cafsk12.cpp \
    dsp/afsk1200/costabf.c \
    dsp/filter/decimator.cpp \
    dsp/filter/fir_decim.cpp \
    dsp/rds/decoder_impl.cc \
    dsp/rds/parser_impl.cc \
    interfaces/udp_sink_f.cpp \
    qtgui/dockfft.cpp \
    qtgui/qtcolorpicker.cpp \
    qtgui/ctk/ctkRangeSlider.cpp \
    receivers/nbrx.cpp \
    receivers/receiver_base.cpp \
    receivers/wfmrx.cpp \
    file_resources.cpp \
    qtgui/dockaudio.cpp \
    qtgui/plotter.cpp \
    qtgui/dockinputctl.cpp \
    pulseaudio/pa_device_list.cc

HEADERS  += mainwindow.h \
    receiver.h \
    dsp/agc_impl.h \
    dsp/correct_iq_cc.h \
    dsp/hbf_decim.h \
    dsp/lpf.h \
    dsp/resampler_xx.h \
    dsp/rx_agc_xx.h \
    dsp/rx_demod_am.h \
    dsp/rx_demod_fm.h \
    dsp/rx_fft.h \
    dsp/rx_filter.h \
    dsp/rx_meter.h \
    dsp/rx_noise_blanker_cc.h \
    dsp/rx_rds.h \
    dsp/sniffer_f.h \
    dsp/stereo_demod.h \
    dsp/afsk1200/cafsk12.h \
    dsp/afsk1200/filter.h \
    dsp/afsk1200/filter-i386.h \
    dsp/filter/decimator.h \
    dsp/filter/filtercoef_hbf_70.h \
    dsp/filter/filtercoef_hbf_100.h \
    dsp/filter/filtercoef_hbf_140.h \
    dsp/filter/fir_decim.h \
    dsp/filter/fir_decim_coef.h \
    dsp/rds/api.h \
    dsp/rds/constants.h \
    dsp/rds/decoder.h \
    dsp/rds/decoder_impl.h \
    dsp/rds/parser.h \
    dsp/rds/parser_impl.h \
    dsp/rds/tmc_events.h \
    interfaces/udp_sink_f.h \
    qtgui/dockfft.h \
    qtgui/qtcolorpicker.h \
    qtgui/ctk/ctkPimpl.h \
    qtgui/ctk/ctkRangeSlider.h \
    receivers/nbrx.h \
    receivers/receiver_base.h \
    receivers/wfmrx.h \
    qtgui/dockaudio.h \
    qtgui/plotter.h \
    qtgui/dockinputctl.h \
    pulseaudio/pa_device_list.h

FORMS    += mainwindow.ui \
   qtgui/dockfft.ui \
    qtgui/dockaudio.ui \
    qtgui/dockinputctl.ui

DISTFILES += \
    sound_off.png \
    sound_on.png \
    dsp/CMakeLists.txt \
    interfaces/CMakeLists.txt \
    receivers/CMakeLists.txt \
    icons/audio-card.svg \
    icons/bookmark-new.svg \
    icons/clear.svg \
    icons/clock.svg \
    icons/close.svg \
    icons/document.svg \
    icons/flash.svg \
    icons/floppy.svg \
    icons/folder.svg \
    icons/fullscreen.svg \
    icons/gqrx.svg \
    icons/help.svg \
    icons/info.svg \
    icons/play.svg \
    icons/power-off.svg \
    icons/radio.svg \
    icons/record.svg \
    icons/refresh.svg \
    icons/settings.svg \
    icons/signal.svg \
    icons/tangeo-network-idle.svg \
    icons/terminal.svg \
    icons/gqrx.ico \
    icons/gqrx.icns \
    HF_Gui.desktop

RESOURCES += \
    image.qrc \
    icons.qrc


#config from gqrx.pro
# enable pkg-config to find dependencies
CONFIG += link_pkgconfig
# make install target
isEmpty(PREFIX) {
    message("No prefix given. Using /usr/local")
    PREFIX=/usr/local
}

target.path  = $$PREFIX/bin
INSTALLS    += target
unix:!macx {
    equals(AUDIO_BACKEND, "portaudio") {
        !packagesExist(portaudio-2.0) {
            error("Portaudio backend requires portaudio19-dev package.")
        }
    }
    isEmpty(AUDIO_BACKEND) {
        packagesExist(libpulse libpulse-simple) {
            # Comment out to use gr-audio
            AUDIO_BACKEND = pulseaudio
        }
    }
}

# Use pulseaudio (ps: could use equals? undocumented)
equals(AUDIO_BACKEND, "pulseaudio"): {
    message("HF_gui configured with pulseaudio backend.")
    PKGCONFIG += libpulse libpulse-simple
    DEFINES += WITH_PULSEAUDIO
    HEADERS += \
        pulseaudio/pa_sink.h \
        pulseaudio/pa_source.h
    SOURCES += \
        pulseaudio/pa_sink.cc \
        pulseaudio/pa_source.cc
} else {
    equals(AUDIO_BACKEND, "portaudio"): {
        message("Gqrx configured with portaudio backend.")
        PKGCONFIG += portaudio-2.0
        DEFINES += WITH_PORTAUDIO
        HEADERS += \
            portaudio/device_list.h \
            portaudio/portaudio_sink.h
        SOURCES += \
            portaudio/device_list.cpp \
            portaudio/portaudio_sink.cpp
    } else {
        message("HF_Gui configured with gnuradio-audio backend.")
        PKGCONFIG += gnuradio-audio
    }
}
macx {
    # FIXME: Mergegr_io_signature into previous one
    HEADERS += osxaudio/device_list.h
    SOURCES += osxaudio/device_list.cpp
}
unix:!macx {
    LIBS += -lboost_system$$BOOST_SUFFIX -lboost_program_options$$BOOST_SUFFIX
    LIBS += -lrt  # need to include on some distros
}

macx {
    LIBS += -lboost_system-mt -lboost_program_options-mt
}


PKGCONFIG += gnuradio-analog \
             gnuradio-blocks \
             gnuradio-digital \
             gnuradio-filter \
             gnuradio-fft \
             gnuradio-runtime \
             gnuradio-osmosdr

INCPATH += src/


unix:!macx {
    LIBS += -lboost_system$$BOOST_SUFFIX -lboost_program_options$$BOOST_SUFFIX
    LIBS += -lrt  # need to include on some distros
}

macx {
    LIBS += -lboost_system-mt -lboost_program_options-mt
}
