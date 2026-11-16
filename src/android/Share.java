package net.sgj0.cordova.plugin.share;

import android.content.Intent;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.json.JSONArray;
import org.json.JSONException;

/**
 * This class echoes a string called from JavaScript.
 */
public class Share extends CordovaPlugin {

  @Override
  public boolean execute(
    String action,
    JSONArray args,
    CallbackContext callbackContext
  ) throws JSONException {
    if ("share".equals(action)) {
      String text = args.optString(0, "");
      String title = args.optString(1, "Share");
      String mimetype = args.optString(2, "text/plain");
      this.share(text, title, mimetype, callbackContext);
      return true;
    }
    return false;
  }

  private void share(
    String text,
    String title,
    String mimetype,
    CallbackContext callbackContext
  ) {
    if (text == null || text.isEmpty()) {
      callbackContext.error("Empty text cannot be shared.");
      return;
    }

    cordova.getActivity().runOnUiThread(() -> {
      try {
        Intent sendIntent = new Intent(Intent.ACTION_SEND);
        sendIntent.putExtra(Intent.EXTRA_TEXT, text);
        if (title != null && !title.isEmpty()) {
          sendIntent.putExtra(Intent.EXTRA_TITLE, title);
          sendIntent.putExtra(Intent.EXTRA_SUBJECT, title);
        }
        sendIntent.setType(
          mimetype != null && !mimetype.isEmpty() ? mimetype : "text/plain"
        );
        cordova
          .getActivity()
          .startActivity(Intent.createChooser(sendIntent, title));
        callbackContext.success();
      } catch (Exception e) {
        callbackContext.error(e.getMessage());
      }
    });
  }
}
