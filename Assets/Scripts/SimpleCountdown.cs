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
                Init(10);
            }
        }
    }

    public void AddTime(int timeToAdd)
    {
        _timeLeft += timeToAdd;
    }
}
