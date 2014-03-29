part of gamelogic;

double clamp(double value, double min, double max)
{
    if (value < min)
    {
        return min;
    }
    else if (value > max)
    {
        return max;
    }
    else
    {
        return value;
    }
}

double lerp(double x1, double x2, double factor)
{
    if (factor < 0.0 || factor > 1.0)
    {
        throw "El factor debe de ser un valor entre 0 y 1";
    }
    else
    {
        double distance = x2 - x1;
        
        return x1 + (distance * factor);
    }
}