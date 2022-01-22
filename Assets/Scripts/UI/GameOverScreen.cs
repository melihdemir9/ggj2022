using System.Collections;
using System.Collections.Generic;
using UnityEditor.SearchService;
using UnityEngine;
using UnityEngine.SceneManagement;
using Scene = UnityEngine.SceneManagement.Scene;

public class GameOverScreen : MonoBehaviour
{
    // Start is called before the first frame update
    void Awake()
    {
        Time.timeScale = 0;
    }

    // Update is called once per frame
    public void ReturnToStart()
    {
        Time.timeScale = 1;
        SceneManager.LoadScene("Scenes/StartScene");
    }
}
