using System;
using System.Collections;
using System.Collections.Generic;
using System.Timers;
using TMPro;
using UnityEngine;

public class SimpleCountdown : MonoBehaviour
{
    private TextMeshProUGUI _tmp;
    private float _timeLeft;
    private bool _timerOn;
    private bool _last3SoundPlayed;

    private void Awake()
    {
        _tmp = GetComponent<TextMeshProUGUI>();
    }

    public void Init(int timeStart)
    {
        _timeLeft = timeStart;
        _timerOn = true;
    }

    void Update()
    {
        if (_timerOn)
        {
            _timeLeft = _timeLeft - Time.deltaTime;
            TimeSpan timeSpan = TimeSpan.FromSeconds((int) _timeLeft);
            _tmp.text = $"{timeSpan.Minutes:D2}:{timeSpan.Seconds:D2}";
            if (_timeLeft < 0)
            {
                _timerOn = false;
                GameFlowController.Instance.Switch();
                _last3SoundPlayed = false;
            }else if (_timeLeft < 3 && !_last3SoundPlayed)
            {
                _last3SoundPlayed = true;
                if(PlayerPrefs.GetInt("sfxOn", 1) == 1) AudioManager.Instance.PlaySound("last3");
            }
        }
    }

    public void AddTime(int timeToAdd)
    {
        _timeLeft += timeToAdd;
        if (_timeLeft <= 3) return;
        AudioManager.Instance.StopSingle();
        _last3SoundPlayed = false;
    }
}
