using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

public class GameFlowController : MonoBehaviour
{
    [SerializeField] private SimpleCountdown _countdown;
    [SerializeField] private List<EnemyController> _enemies;
    [SerializeField] private GameObject _collectibleKeyPrefab;
    [SerializeField] private GameObject _collectibleTimePrefab;
    [SerializeField] private Transform _collectibleParent;
    [SerializeField] private Transform _player;
    public int TotalKeyCount;

    //temp
    [SerializeField] private Transform canvas;
    [SerializeField] private GameObject gameOverScreen;
    [SerializeField] private Camera _sceneCamera;
    [SerializeField] private Light _lightSource;
    [SerializeField] private PostProcessVolume _postProcessVolume;

    [HideInInspector] public int KeyProgress = 0;
    [HideInInspector] public bool NightMode;
    
    private List<Vector3> _enemyLocations = new List<Vector3>();
    private List<Vector3> _possibleKeyLocations = new List<Vector3>();
    private List<GameObject> _collectibleKeys = new List<GameObject>();
    private List<Vector3> _timeLocations = new List<Vector3>();
    private List<GameObject> _collectibleTimes = new List<GameObject>();
    public float MaxDistance;

    public static GameFlowController Instance;
    [HideInInspector]public bool IsReady = false;
    private void Awake()
    {
        Instance = this;

        ProcessEnemyMarkers();
        ProcessKeyMarkers();
        ProcessTimeMarkers();
        
        //starts as day
        NightMode = false;
        SwitchToDay();
        
        IsReady = true;
    }

    private void ProcessEnemyMarkers()
    {
        EnemyMarker[] markers = FindObjectsOfType<EnemyMarker>();
        foreach (var enemyMarker in markers)
        {
            _enemyLocations.Add(enemyMarker.transform.position);
            Destroy(enemyMarker.gameObject);
        }
    }

    private void ProcessKeyMarkers()
    {
        KeyMarker[] markers = FindObjectsOfType<KeyMarker>();
        foreach (var keyMarker in markers)
        {
            _possibleKeyLocations.Add(keyMarker.transform.position);
            Destroy(keyMarker.gameObject);
        }

        for (int i = 0; i < TotalKeyCount; ++i)
        {
            int randIndex = Random.Range(0, _possibleKeyLocations.Count);
            _collectibleKeys.Add(Instantiate(_collectibleKeyPrefab, _possibleKeyLocations[randIndex], Quaternion.identity, _collectibleParent));
            _possibleKeyLocations.RemoveAt(randIndex);
        }
    }
    
    private void ProcessTimeMarkers()
    {
        TimeMarker[] markers = FindObjectsOfType<TimeMarker>();
        foreach (var timeMarker in markers)
        {
            _timeLocations.Add(timeMarker.transform.position);
            Destroy(timeMarker.gameObject);
        }
    }

    public void AddTime(int timeToAdd)
    {
        _countdown.AddTime(timeToAdd);
    }

    private void SwitchToDay()
    {
        AudioManager.Instance.StopLoop();
        AudioManager.Instance.LoopSound("dayAmbience", 0.3f);
        
        _sceneCamera.clearFlags = CameraClearFlags.Skybox;
        _lightSource.intensity = 1.22f;
        _postProcessVolume.profile.GetSetting<Vignette>().color.value = new Color(0.3176471f, 0.6705883f, 0.8980392f);

        foreach (var enemy in _enemies)
        {
            enemy.gameObject.SetActive(false);
        }

        foreach (var key in _collectibleKeys)
        {
            key.gameObject.SetActive(true);
        }

        foreach (var timeLocation in _timeLocations)
        {
            if (Random.Range(0f, 1f) > 0.5f)
            {
                _collectibleTimes.Add(Instantiate(_collectibleTimePrefab, timeLocation, Quaternion.identity, _collectibleParent));
            }
        }

        NightMode = false;
        _countdown.Init(15);
    }

    private void SwitchToNight()
    {
        AudioManager.Instance.StopLoop();
        AudioManager.Instance.LoopSound("nightAmbience");

        _sceneCamera.clearFlags = CameraClearFlags.SolidColor;
        _lightSource.intensity = 0.2f;
        _postProcessVolume.profile.GetSetting<Vignette>().color.value = Color.red;

        
        bool[] spawnedEnemyHere = new bool[_enemyLocations.Count];
        foreach (var enemy in _enemies)
        {
            int currentFarthestIndex = 0;
            float currentLongestDistance = 0f;
            for (int i = 0; i < _enemyLocations.Count; ++i)
            {
                if (currentLongestDistance >= Vector3.Distance(_player.position, _enemyLocations[i]) ||
                    spawnedEnemyHere[i]) continue;
                currentFarthestIndex = i;
                currentLongestDistance = Vector3.Distance(_player.position, _enemyLocations[i]);
            }

            enemy.transform.position = _enemyLocations[currentFarthestIndex];
            enemy.gameObject.SetActive(true);
            spawnedEnemyHere[currentFarthestIndex] = true;
        }
        
        foreach (var key in _collectibleKeys)
        {
            key.gameObject.SetActive(false);
        }

        foreach (var collectibleTime in _collectibleTimes)
        {
            Destroy(collectibleTime.gameObject);
        }
        
        NightMode = true;
        _countdown.Init(15);
    }

    public void Switch()
    {
        NightMode = !NightMode; //ew
        if(NightMode) SwitchToNight(); //ew
        else SwitchToDay(); //ew
    }

    public void IterateKey(GameObject key)
    {
        if (KeyProgress == TotalKeyCount - 1)
        {
            //temp
            Instantiate(gameOverScreen, canvas);
        }
        else
        {
            KeyProgress++;
            _collectibleKeys.Remove(key);
            Destroy(key);
        }
    }

    public float GetProximityVolumeForKey(Vector3 keyPos)
    {
        return 1f - (Vector3.Distance(_player.position, keyPos) / MaxDistance);
    }
}
