import Toybox.Activity;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

class PowerNormalizer130View extends WatchUi.DataField
{
    hidden var _sumOfPowered as Float;
    hidden var _avgOfPowered as Float;
    hidden var _buffer as Array;
    hidden var _nBuffered as Number;
    hidden var _nTotal as Number;
    hidden var _frontIndex as Number;
    hidden var _prevTime as Number;

    function initialize()
    {
		// basic init
        DataField.initialize();
        _prevTime = 0;
        _sumOfPowered = 0.0f;
        _avgOfPowered = 0.0f;
        _nTotal = 0;

        // create buffer
        _buffer = new[30];
        _frontIndex = 0;
        _nBuffered = 0;
    }

    // Set your layout here.
    function onLayout(dc as Dc) as Void
    {
        View.setLayout(Rez.Layouts.MainLayout(dc));
        
        // var valueView = View.findDrawableById("value");
    }

    // The given info object contains all the current workout information. Calculate a value and save it locally in this method.
    // Note that compute() and onUpdate() are asynchronous, and there is no guarantee that compute() will be called before onUpdate().
    function compute(info as Activity.Info) as Void
    {
    	// check info
    	if(!(info has :currentPower)) { return; }
        if(!(info has :timerTime)) { return; }

        // check elapsed time
        if(info.timerTime == null || info.timerTime == _prevTime) { return; }
        _prevTime = info.timerTime;
        
    	// get current power, buffer value
        var powerSample as Float = info.currentPower != null ? info.currentPower * 1.0f : 0.0f;
        _buffer[_frontIndex] = powerSample;
        _frontIndex++;
        if(_nBuffered < _buffer.size()) { _nBuffered++; }
        if(_frontIndex == _buffer.size()) { _frontIndex = 0; }

        // calculate average
        var powerAvg as Float = 0.0f;
        var i as Number = 0;
        while(i < _nBuffered)
        {
            powerAvg += _buffer[i];
            i++;
        }
        powerAvg /= _nBuffered;

        // calculate average of fourth powers
        _sumOfPowered += powerAvg * powerAvg * powerAvg * powerAvg;
        _nTotal++;
        _avgOfPowered = _sumOfPowered/_nTotal;
    }

    // Display the value you computed here. This will be called once a second when the data field is visible.
    function onUpdate(dc as Dc) as Void
    {
    	// set the background color
        (View.findDrawableById("Background") as Text).setColor(Graphics.COLOR_WHITE);
                  
        // set value
        var value = View.findDrawableById("value") as Text;
        value.setText(Math.pow(_avgOfPowered, 0.25f).format("%.1f"));

        // call parent's onUpdate(dc) to redraw the layout
        View.onUpdate(dc);
    }

}
