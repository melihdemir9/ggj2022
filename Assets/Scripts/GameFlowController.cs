using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameFlowController : MonoBehaviour
{
    [SerializeField] private SimpleCountdown _countdown;
    public static GameFlowController Instance;
    private void Awake()
    {
        Instance = this;
    }
    
    void Start()
    {
        _countdown.Init(75);
    }

    public void AddTime(int timeToAdd)
    {
        _countdown.AddTime(timeToAdd);
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
