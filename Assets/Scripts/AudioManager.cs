using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AudioManager : MonoBehaviour
{
    public static AudioManager Instance;
    [SerializeField] private List<string> SoundNames;
    [SerializeField] private List<AudioClip> SoundClips;

    private Dictionary<string, AudioClip> SoundsDictionary;
    [SerializeField] private AudioSource _singleSource;
    [SerializeField] private AudioSource _loopSource;

    public bool IsReady;
    
    private void Awake()
    {
        DontDestroyOnLoad(this);
        Instance = this;

        SoundsDictionary = new Dictionary<string, AudioClip>();
        for (int i = 0; i < SoundNames.Count; ++i)
        {
            SoundsDictionary.Add(SoundNames[i], SoundClips[i]);
        }

        IsReady = true;
    }

    public void PlaySound(string soundName, float volume = 1f)
    {
        _singleSource.volume = volume;
        _singleSource.clip = SoundsDictionary[soundName];
        _singleSource.Play();
    }

    public void StopSingle()
    {
        _singleSource.Stop();
    }

    public void LoopSound(string soundName, float volume = 1f)
    {
        _loopSource.volume = volume;
        _loopSource.loop = true;
        _loopSource.clip = SoundsDictionary[soundName];
        _loopSource.Play();
    }

    public void StopLoop()
    {
        _loopSource.Stop();
    }
}
