using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class MainSceneTutorialHelper : MonoBehaviour
{

    [SerializeField] private Button TutorialImage;

    public void ShowTutorial(Action OnComplete)
    {
        Time.timeScale = 0;
        TutorialImage.gameObject.SetActive(true);
        
        TutorialImage.onClick.AddListener(() =>
        {
            Time.timeScale = 1;
            TutorialImage.gameObject.SetActive(false);
            OnComplete();
        });
    }
}
