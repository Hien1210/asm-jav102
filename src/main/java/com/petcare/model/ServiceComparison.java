package com.petcare.model;

import java.io.Serializable;

public class ServiceComparison implements Serializable {
    private String serviceName;
    private String whenToChoose;
    private String mainIncludes;
    private String askBeforeIf;
    private String buttonText;
    private String buttonTheme;
    private String targetService;

    public ServiceComparison() {
    }

    public ServiceComparison(String serviceName, String whenToChoose, String mainIncludes,
                             String askBeforeIf, String buttonText, String buttonTheme, String targetService) {
        this.serviceName = serviceName;
        this.whenToChoose = whenToChoose;
        this.mainIncludes = mainIncludes;
        this.askBeforeIf = askBeforeIf;
        this.buttonText = buttonText;
        this.buttonTheme = buttonTheme;
        this.targetService = targetService;
    }

    public String getServiceName() { return serviceName; }
    public void setServiceName(String serviceName) { this.serviceName = serviceName; }

    public String getWhenToChoose() { return whenToChoose; }
    public void setWhenToChoose(String whenToChoose) { this.whenToChoose = whenToChoose; }

    public String getMainIncludes() { return mainIncludes; }
    public void setMainIncludes(String mainIncludes) { this.mainIncludes = mainIncludes; }

    public String getAskBeforeIf() { return askBeforeIf; }
    public void setAskBeforeIf(String askBeforeIf) { this.askBeforeIf = askBeforeIf; }

    public String getButtonText() { return buttonText; }
    public void setButtonText(String buttonText) { this.buttonText = buttonText; }

    public String getButtonTheme() { return buttonTheme; }
    public void setButtonTheme(String buttonTheme) { this.buttonTheme = buttonTheme; }

    public String getTargetService() { return targetService; }
    public void setTargetService(String targetService) { this.targetService = targetService; }
}

