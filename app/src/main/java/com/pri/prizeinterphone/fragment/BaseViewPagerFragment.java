package com.pri.prizeinterphone.fragment;

import android.app.ProgressDialog;
import android.content.Context;
import android.net.Uri;
import android.os.Bundle;
import android.os.Handler;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.TextView;
import androidx.fragment.app.Fragment;
import com.pri.prizeinterphone.R;
import com.pri.prizeinterphone.Util.Clog;

public class BaseViewPagerFragment extends Fragment {
    private static final String ARG_PARAM1 = "param1";
    private static final String ARG_PARAM2 = "param2";
    private static final String TAG = "BaseViewPagerFragment";
    public int mCurrentPosition;
    public Runnable mDismissRunnable = new Runnable() {
        public void run() {
            BaseViewPagerFragment.this.dismissProgressDialog();
        }
    };
    public ImageView mFragmentAdd;
    public FrameLayout mFragmentContainer;
    public TextView mFragmentTile;
    public Handler mHandler = new Handler();
    private OnFragmentInteractionListener mListener;
    private String mParam1;
    private String mParam2;
    private ProgressDialog mProgressDialog;
    public View mRootView;
    public String mTitle;

    public interface OnFragmentInteractionListener {
        void onFragmentInteraction(Uri uri);
    }

    public void doAddAction() {
    }

    public String getMyTag() {
        return TAG;
    }

    public void updateView() {
    }

    public BaseViewPagerFragment() {
    }

    public BaseViewPagerFragment(String str) {
        this.mTitle = str;
    }

    public static BaseViewPagerFragment newInstance(String str, String str2) {
        BaseViewPagerFragment baseViewPagerFragment = new BaseViewPagerFragment();
        Bundle bundle = new Bundle();
        bundle.putString(ARG_PARAM1, str);
        bundle.putString(ARG_PARAM2, str2);
        baseViewPagerFragment.setArguments(bundle);
        return baseViewPagerFragment;
    }

    public void onCreate(Bundle bundle) {
        super.onCreate(bundle);
        if (getArguments() != null) {
            this.mParam1 = getArguments().getString(ARG_PARAM1);
            this.mParam2 = getArguments().getString(ARG_PARAM2);
        }
    }

    public View onCreateView(LayoutInflater layoutInflater, ViewGroup viewGroup, Bundle bundle) {
        this.mRootView = layoutInflater.inflate(R.layout.fragment_base_view_pager, viewGroup, false);
        Clog.d(getMyTag(), "onCreateView->initView");
        initView(this.mRootView);
        return this.mRootView;
    }

    public void initView(View view) {
        this.mFragmentTile = (TextView) view.findViewById(R.id.fragment_title);
        updateTitle();
        ImageView imageView = (ImageView) view.findViewById(R.id.fragment_add);
        this.mFragmentAdd = imageView;
        imageView.setOnClickListener(new View.OnClickListener() {
            public void onClick(View view) {
                BaseViewPagerFragment.this.doAddAction();
            }
        });
        this.mFragmentContainer = (FrameLayout) this.mRootView.findViewById(R.id.fragment_container);
    }

    public void setTitle(String str) {
        TextView textView = this.mFragmentTile;
        if (textView != null) {
            textView.setText(str);
        }
    }

    public void setAddButton(int i) {
        this.mFragmentAdd.setVisibility(0);
        this.mFragmentAdd.setImageDrawable(getActivity().getResources().getDrawable(i));
    }

    public void setCurrentPosition(int i) {
        this.mCurrentPosition = i;
    }

    public void updateTitle() {
        String str = this.mTitle;
        if (str != null) {
            setTitle(str);
        }
    }

    public void onButtonPressed(Uri uri) {
        OnFragmentInteractionListener onFragmentInteractionListener = this.mListener;
        if (onFragmentInteractionListener != null) {
            onFragmentInteractionListener.onFragmentInteraction(uri);
        }
    }

    public void onAttach(Context context) {
        super.onAttach(context);
    }

    public void onDetach() {
        super.onDetach();
        this.mListener = null;
    }

    public void showProgressDialog(String str) {
        if (this.mProgressDialog == null) {
            this.mProgressDialog = new ProgressDialog(getActivity());
        }
        this.mProgressDialog.setMessage(str);
        this.mProgressDialog.setCancelable(false);
        this.mProgressDialog.show();
    }

    public void dismissProgressDialog() {
        if (this.mProgressDialog != null && isAdded()) {
            this.mProgressDialog.dismiss();
        }
    }
}
