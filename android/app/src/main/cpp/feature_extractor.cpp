#include <cstdint>
#include <cmath>

extern "C"
{

    // img: pointer to width*height bytes (grayscale 0–255)
    // width, height: image dimensions
    // out: pointer to at least 4 floats (output features)
    void compute_features(const uint8_t *img, int32_t width, int32_t height, float *out)
    {
        int32_t n = width * height;
        if (n <= 0)
        {
            out[0] = out[1] = out[2] = out[3] = 0.0f;
            return;
        }

        long long sum = 0;
        long long sumsq = 0;
        uint8_t minv = 255;
        uint8_t maxv = 0;

        for (int32_t i = 0; i < n; ++i)
        {
            uint8_t v = img[i];
            sum += v;
            sumsq += static_cast<long long>(v) * v;
            if (v < minv)
                minv = v;
            if (v > maxv)
                maxv = v;
        }

        float mean = static_cast<float>(sum) / static_cast<float>(n);
        float var = static_cast<float>(sumsq) / static_cast<float>(n) - mean * mean;
        if (var < 0)
            var = 0;
        float std = std::sqrt(var);

        // Normalize to [0,1] for safety
        out[0] = mean / 255.0f;
        out[1] = std / 255.0f;
        out[2] = static_cast<float>(minv) / 255.0f;
        out[3] = static_cast<float>(maxv) / 255.0f;
    }

} // extern "C"
