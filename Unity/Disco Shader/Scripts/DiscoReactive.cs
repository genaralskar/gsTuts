using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DiscoReactive : MonoBehaviour
{
    [SerializeField] AudioSource source;
    [SerializeField] int sampleSize = 1024;
    [SerializeField] float updateRate = 0.1f;
    [SerializeField] Vector2 sizeBounds = new Vector2(0, .3f);
    [SerializeField] Material discoMat;
    [Range(0, 1)]
    [SerializeField] float volumeDivider = .5f;
    [SerializeField] float falloffSpeed = .3f;

    [Header("Frequency Stuff")]
    [SerializeField] Vector2 frequenceyRange = new Vector2(0, 48000);

    private float volume;
    private float[] clipSampleData;

    private void Awake()
    {
        clipSampleData = new float[sampleSize];
    }

    private void Start()
    {
        StartCoroutine(Reactor());
    }

    private IEnumerator Reactor()
    {
        WaitForEndOfFrame wait = new WaitForEndOfFrame();

        float timer = 0;

        float tempVolume;

        while(true)
        {
            if(timer > updateRate)
            {
                source.GetSpectrumData(clipSampleData, 0, FFTWindow.Rectangular);

                tempVolume = 0;

                int startIndex = GetFrequencyRangeIndex(frequenceyRange.x);
                int stopIndex = GetFrequencyRangeIndex(frequenceyRange.y);

                for (int i = startIndex; i < stopIndex; i++)
                {
                    tempVolume += Mathf.Abs(clipSampleData[i]);
                }

                tempVolume *= volumeDivider;

                tempVolume = Mathf.Clamp(tempVolume, sizeBounds.x, sizeBounds.y);

                if(tempVolume > volume)
                {
                    volume = tempVolume;
                }

                SetCircleSize(volume);

                timer = 0;
            }

            SizeFalloff();

            timer += Time.deltaTime;
            yield return wait;
        }
    }

    private void SetCircleSize(float size)
    {
        discoMat.SetFloat("_CircleSize", size);
    }

    private int GetFrequencyRangeIndex(float input)
    {
        float cu = 48000 / sampleSize;
        return Mathf.Clamp((int)(input / cu), 0, sampleSize);
    }

    private void SizeFalloff()
    {
        if(volume > sizeBounds.x)
        {
            volume -= falloffSpeed * Time.deltaTime;
            volume = Mathf.Clamp(volume, sizeBounds.x, sizeBounds.y);
        }
    }
}
