using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;

public class KeyCounter : MonoBehaviour
{

    public void UpdateCounter(int keyProgress, int totalKeyCount)
    {
        GetComponent<TextMeshProUGUI>().text = keyProgress + "/" + totalKeyCount;
    }
}
