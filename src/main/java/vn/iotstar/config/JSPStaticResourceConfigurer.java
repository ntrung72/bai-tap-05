package vn.iotstar.config;

import java.net.URI;
import java.net.URL;
import org.apache.catalina.Context;
import org.apache.catalina.Lifecycle;
import org.apache.catalina.LifecycleEvent;
import org.apache.catalina.LifecycleListener;
import org.apache.catalina.WebResourceRoot;
import org.springframework.util.ResourceUtils;

public class JSPStaticResourceConfigurer implements LifecycleListener {
    private final Context context;
    private final String subPath="/META-INF";
    public JSPStaticResourceConfigurer(Context context) {
        this.context=context;
    }
    @Override
    public void lifecycleEvent(LifecycleEvent event) {
        if(!Lifecycle.CONFIGURE_START_EVENT.equals(event.getType()))return;
        context.getResources().createWebResourceSet(WebResourceRoot.ResourceSetType.RESOURCE_JAR,"/",getUrl(),subPath);
    }
    private URL getUrl() {
        URL location=getClass().getProtectionDomain().getCodeSource().getLocation();
        if(ResourceUtils.isFileURL(location))return location;
        if(ResourceUtils.isJarURL(location))try {
            String path=location.getPath().replaceFirst("^nested:","").replaceFirst("/!BOOT-INF/classes/!/$","!/");
            return new URI("jar","file:"+path,null).toURL();
        } catch(Exception e) {
            throw new IllegalStateException("Unable to add JSP source URI",e);
        }
        throw new IllegalStateException("Unsupported JSP source URL: "+location);
    }
}
