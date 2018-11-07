#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include<receiver.h>
#include<qtgui/dockfft.h>
#include <QTimer>
#include<QPointer>
#include<QComboBox>
#include"qtgui/dockaudio.h"
#include"qtgui/dockinputctl.h"
#include"dsp/afsk1200/cafsk12.h"
#ifdef WITH_PULSEAUDIO
#include "pulseaudio/pa_device_list.h"
#elif WITH_PORTAUDIO
#include "portaudio/device_list.h"
#elif defined(GQRX_OS_MACX)
#include "osxaudio/device_list.h"
#endif

#define FILTER_PRESET_WIDE      0
#define FILTER_PRESET_NORMAL    1
#define FILTER_PRESET_NARROW    2
#define FILTER_PRESET_USER      3
namespace Ui {
class MainWindow;
}

class MainWindow : public QMainWindow
{
    Q_OBJECT
public:
    qint64 Frequency_centrer_value=91000000.0;
    qint64 Frequency_bandwith=1000000.0;
    qint64 Frequency_OffSet=0.0;
    QStringList *ArrayinputDevevice=new QStringList;
    QString NameDevieceOutput="default";
    QString DeveiceInput=NULL;
 //   qint64 d_hw_freq;

    qint64 d_lnb_lo;  /* LNB LO in Hz. */
    qint64 d_hw_freq;
    /* data decoders */
  //  Afsk1200Win    *dec_afsk1200;

    //QInputMethod *mInputmethod;
    bool mute_sound=false,Start_HF=false;
    receiver *rx;
    QTimer   *meter_timer;
    DockFft      *uiDockFft;
    DockAudio *uiDockAudio;
    DockInputCtl   *uiDockInputCtl;



    QPointer<QSettings> m_settings;
    std::map<QString, QVariant> devList;
    QVarLengthArray<float, 16384> tmpbuf;
    CAfsk12 *decoder;



    /*!< Application wide settings. */



public:
    explicit MainWindow(QWidget *parent = 0);
    ~MainWindow();
 enum rxopt_mode_idx {
     MODE_OFF        = 0, /*!< Demodulator completely off. */
     MODE_RAW        = 1, /*!< Raw I/Q passthrough. */
     MODE_AM         = 2, /*!< Amplitude modulation. */
     MODE_NFM        = 3, /*!< Narrow band FM. */
     MODE_WFM_MONO   = 4, /*!< Broadcast FM (mono). */
     MODE_WFM_STEREO = 5, /*!< Broadcast FM (stereo). */
     MODE_LSB        = 6, /*!< Lower side band. */
     MODE_USB        = 7, /*!< Upper side band. */
     MODE_CWL        = 8, /*!< CW using LSB filter. */
     MODE_CWU        = 9, /*!< CW using USB filter. */
     MODE_WFM_STEREO_OIRT = 10, /*!< Broadcast FM (stereo oirt). */
     MODE_LAST       = 11
 };


private:
    Ui::MainWindow *ui;
public:
    void SetLable(int number);
    void getDevieceOutputAudio(QString Name);
    static QStringList ModulationStrings;
    void process_samples(float *buffer, int length);
    void setFrequency_Center();
    void GetlistAudioOuput();
    void getSampleRateInput();
    void SetupforDockInputCtl();
    void updateGainStages(bool read_from_device);
    void getaudiooutput(QComboBox *combobox);
    void getDeviceInputList1(std::map<QString, QVariant> &devList, QComboBox *combobox,QStringList* ArrayListDevieceInput);
private slots:

    void on_NB_AFC_radioButton_clicked();
    void on_AGC_radioButton_clicked();
    void on_APF_IF_radioButton_clicked();
    void on_Attenuation_10_radioButton_clicked();
    void on_Attenuation_30_radioButton_clicked();
    void on_pushButton_mute_sound_clicked();
    void on_actionExit_triggered();
    void on_actionFFT_Setting_triggered();
    void setNewFrequency(int rx_freq_int);
    void setSquechvalue(int Squechvalue);
    void decoderTimeout();
     void selectDemod(int mode_idx);
     void setInputdeviece(int index);
     void setinputSampleRate(int SampleRateInput);
    void setAudioGain(int valueint);
    void setGain(QString name, double gain);
    void setAutoGain(bool enabled);
    void setIqSwap(bool reversed);
    void setDcCancel(bool enabled);
    void setIqBalance(bool enabled);
    void setAntenna(const QString antenna);
    void setDecimation(int Decimation_index);
    void setAgcGain(int gain);




    // function
    void meterTimeout();


    void on_Start_pushButton_clicked();
    void on_Mode_band_comboBox_currentIndexChanged(int index);
    void on_Recorder_radioButton_toggled(bool checked);
    void on_Deveice_Output_Audio_comboBox_currentIndexChanged(const QString &arg1);
    void on_Frequency_Centrer_value_spinBox_valueChanged(int arg1);
    void on_Frequency_OffSet_value_SpinBox_valueChanged(int arg1);
    void on_BandWidth_value_SpinBox_2_valueChanged(int arg1);
    void on_Sample_Rate_Input_comboBox_currentIndexChanged(int index);

    void on_reset_pushButton_clicked();
    void on_Show_dockinput_control_checkBox_toggled(bool checked);
    void setAudioOutputDevice(int index);
    void startAudioStream(const QString udp_host, int udp_port);
    void stopAudioStreaming();    

signals:
    int SampleRateInputValuechange(int Samplerate);

private:
#ifdef WITH_PULSEAUDIO
    vector<pa_device>           outDevList;
#elif WITH_PORTAUDIO
    vector<portaudio_device>    outDevList;
#elif defined(GQRX_OS_MACX)
    vector<osxaudio_device>     outDevList;
#endif
};


#endif // MAINWINDOW_H
