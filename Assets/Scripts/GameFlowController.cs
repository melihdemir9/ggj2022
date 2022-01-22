using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameFlowController : MonoBehaviour
{
    [SerializeField] private SimpleCountdown _countdown;
    [SerializeField] private List<EnemyController> _enemies;
    [SerializeField] private GameObject _collectibleKeyPrefab;
    [SerializeField] private GameObject _collectibleTimePrefab;
    [SerializeField] private List<Vector3> _enemyLocations;
    [SerializeField] private List<Vector3> _keyLocations;
    [SerializeField] private List<Vector3> _timeLocations;
    [SerializeField] private Transform _collectibleParent;
    [SerializeField] private Transform _player;
    
    //temp
    [SerializeField] private Transform canvas;
    [SerializeField] private GameObject gameOverScreen;

    [HideInInspector] public int KeyProgress = 0;
    [HideInInspector] public int TotalKeyCount;
    [HideInInspector] public bool NightMode;
    private List<GameObject> _collectibleTimes = new List<GameObject>();
    private GameObject _collectibleKey;

    public static GameFlowController Instance;
    public bool IsReady = false;
    private void Awake()
    {
        Instance = this;
    }
    
    void Start()
    {
        AudioManager.Instance.LoopSound("dayAmbience");
        TotalKeyCount = _keyLocations.Count;
        //starts as day
        NightMode = false;
        _collectibleKey = Instantiate(_collectibleKeyPrefab, _keyLocations[KeyProgress], Quaternion.identity, _collectibleParent);
        SwitchToDay();
        IsReady = true;
    }

    public void AddTime(int timeToAdd)
    {
        _countdown.AddTime(timeToAdd);
    }

    private void SwitchToDay()
    {
        foreach (var enemy in _enemies)
        {
            enemy.gameObject.SetActive(false);
        }
        
        _collectibleKey.gameObject.SetActive(true);

        foreach (var timeLocation in _timeLocations)
        {
            if (Random.Range(0, 1) > 0.5f)
            {
                _collectibleTimes.Add(Instantiate(_collectibleTimePrefab, timeLocation, Quaternion.identity, _collectibleParent));
            }
        }

        NightMode = false;
        Debug.Log("It is now day");
        _countdown.Init(15);
    }

    private void SwitchToNight()
    {
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
        
        _collectibleKey.gameObject.SetActive(false);

        foreach (var collectibleTime in _collectibleTimes)
        {
            Destroy(collectibleTime.gameObject);
        }
        
        NightMode = true;
        Debug.Log("It is now night");
        _countdown.Init(15);
    }

    public void Switch()
    {
        NightMode = !NightMode; //ew
        if(NightMode) SwitchToNight(); //ew
        else SwitchToDay(); //ew
    }

    public void IterateKey()
    {
        if (KeyProgress == TotalKeyCount - 1)
        {
            //temp
            Instantiate(gameOverScreen, canvas);
        }
        else
        {
            KeyProgress++;
            _collectibleKey.transform.position = _keyLocations[KeyProgress];
        }
    }
}
