import Toybox.Activity;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;
using Toybox.Application.Storage;

class PowerNormalizer130View extends WatchUi.DataField
{
	hidden var _currentPower as Float;
    hidden var _nData as Number;

    function initialize()
    {
		// basic init
        DataField.initialize();
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
        
    	// get current power
        _currentPower = info.currentPower != null ? info.currentPower * 1.0f : 0.0f;
    }

    // Display the value you computed here. This will be called once a second when the data field is visible.
    function onUpdate(dc as Dc) as Void
    {
    	// set the background color
        (View.findDrawableById("Background") as Text).setColor(Graphics.COLOR_WHITE);
                  
        // set value
        var value = View.findDrawableById("value") as Text;
        value.setText(_currentPower.format("%.2f"));

        // call parent's onUpdate(dc) to redraw the layout
        View.onUpdate(dc);
    }

}
