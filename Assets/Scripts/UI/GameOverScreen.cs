using UnityEngine;
using UnityEngine.SceneManagement;

public class GameOverScreen : MonoBehaviour
{
    // Start is called before the first frame update
    void Awake()
    {
        Cursor.visible = true;
        Time.timeScale = 0;
    }

    // Update is called once per frame
    public void ReturnToStart()
    {
        Time.timeScale = 1;
        SceneManager.LoadScene("Scenes/StartScene");
    }
}
