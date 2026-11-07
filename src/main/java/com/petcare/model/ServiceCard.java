package com.petcare.model;

import java.io.Serializable;
import java.util.List;

public class ServiceCard implements Serializable {
    private String id;
    private String category;
    private String badgeText;
    private String badgeTheme;
    private String ratingText;
    private String title;
    private String description;
    private List<String> tags;
    private String priceLabel;
    private String priceValue;
    private String priceSuffix;

    public ServiceCard() {
    }

    public ServiceCard(String id, String category, String badgeText, String badgeTheme,
                       String ratingText, String title, String description,
                       List<String> tags, String priceLabel, String priceValue, String priceSuffix) {
        this.id = id;
        this.category = category;
        this.badgeText = badgeText;
        this.badgeTheme = badgeTheme;
        this.ratingText = ratingText;
        this.title = title;
        this.description = description;
        this.tags = tags;
        this.priceLabel = priceLabel;
        this.priceValue = priceValue;
        this.priceSuffix = priceSuffix;
    }

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public String getBadgeText() { return badgeText; }
    public void setBadgeText(String badgeText) { this.badgeText = badgeText; }

    public String getBadgeTheme() { return badgeTheme; }
    public void setBadgeTheme(String badgeTheme) { this.badgeTheme = badgeTheme; }

    public String getRatingText() { return ratingText; }
    public void setRatingText(String ratingText) { this.ratingText = ratingText; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public List<String> getTags() { return tags; }
    public void setTags(List<String> tags) { this.tags = tags; }

    public String getPriceLabel() { return priceLabel; }
    public void setPriceLabel(String priceLabel) { this.priceLabel = priceLabel; }

    public String getPriceValue() { return priceValue; }
    public void setPriceValue(String priceValue) { this.priceValue = priceValue; }

    public String getPriceSuffix() { return priceSuffix; }
    public void setPriceSuffix(String priceSuffix) { this.priceSuffix = priceSuffix; }
}
